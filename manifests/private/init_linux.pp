# Main manifest for the Linux platform
# The Darwin entry point is so small it is folded into ../init.pp instead
class epfl_sso::private::init_linux(
  $allowed_users_and_groups,
  $manage_nsswitch_netgroup,
  $enable_mkhomedir,
  $home_automounts,
  $auth_source,
  $directory_source,
  $needs_nscd,
  $ad_server,
  $realm,
  $join_domain,
  $renew_domain_credentials,
  $sshd_gssapi_auth,
  $debug_sssd
) {
  ensure_resource('class', 'quirks')

  class { "epfl_sso::private::package_sources": }
  class { "epfl_sso::private::login_shells": }
  if (str2bool($::is_lightdm_active)) {
    class { "epfl_sso::private::lightdm":  }
  }

  package { $epfl_sso::private::params::sssd_packages :
    ensure => present
  } ->
  file { '/etc/sssd/sssd.conf' :
    ensure  => present,
    content => template('epfl_sso/sssd.conf.erb'),
    # The template above uses variables $debug_sssd, $auth_source and
    # $ad_server
    owner   => root,
    group   => root,
    mode    => '0600'
  } ~>
  service { 'sssd':
    ensure => running,
    enable => true
  }

  include epfl_sso::private::pam
  epfl_sso::private::pam::module { "sss": }

  if ($needs_nscd) {
    package { "nscd":
      ensure => present
    }
  }

  # A properly configured clock is necessary for Kerberos:
  ensure_resource('class', 'ntp')

  if ($allowed_users_and_groups != undef) {
    class { 'epfl_sso::private::access':
      allowed_users_and_groups => $allowed_users_and_groups
    }
  }

  name_service {['passwd', 'group']:
    lookup => ['compat', 'sss']
  }

  # This is necessary for RH7 and CentOS 7, and probably
  # does not hurt for older versions:
  name_service { 'initgroups':
    # https://bugzilla.redhat.com/show_bug.cgi?id=751450
    lookup => ['files [SUCCESS=continue] sss']
  }

  if ($manage_nsswitch_netgroup) {
    name_service { 'netgroup':
      lookup => ['files', 'sss']
    }
  }

  if ($enable_mkhomedir) {
    class { 'epfl_sso::private::mkhomedir': }
  }

  epfl_sso::private::pam::module { "winbind":
    ensure => "absent"
  }

  if ($auth_source == "AD" or $directory_source == "AD") {
    class { "epfl_sso::private::ad":
      join_domain              => $join_domain,
      renew_domain_credentials => $renew_domain_credentials,
      ad_server                => $ad_server,
      realm                    => $realm
    }
  }

  if ($sshd_gssapi_auth != undef) {
    class { "epfl_sso::private::sshd":
      enable_gssapi => $sshd_gssapi_auth
    }
  }

  if ($home_automounts) {
    class { "epfl_sso::private::nfs": }
    class { "epfl_sso::private::home_automounts": }
  }
}
