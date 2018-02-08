# Main manifest for the Linux platform
# The Darwin entry point is so small it is folded into ../init.pp instead
class epfl_sso::private::init_linux(
  $allowed_users_and_groups,
  $manage_nsswitch_netgroup,
  $enable_mkhomedir,
  $ad_automount_home,
  $auth_source,
  $directory_source,
  $needs_nscd,
  $ad_server,
  $ad_server_base_dn,
  $realm,
  $join_domain,
  $renew_domain_credentials,
  $sshd_gssapi_auth,
  $debug_gssd,
  $debug_sssd
) {
  ensure_resource('class', 'quirks')

  class { "epfl_sso::private::package_sources": }
  class { "epfl_sso::private::login_shells": }
  if (str2bool($::is_lightdm_active)) {
    class { "epfl_sso::private::lightdm":  }
  }

  class { "epfl_sso::private::sss":
    auth_source              => $auth_source,
    directory_source         => $directory_source,
    ad_server                => $ad_server,
    ad_server_base_dn        => $ad_server_base_dn,
    ad_automount_home        => $ad_automount_home,
    debug_sssd               => $debug_sssd,
    manage_nsswitch_netgroup => $manage_nsswitch_netgroup
  }

  if ($needs_nscd) {
    package { "nscd":
      ensure => present
    }
  }

  # A properly configured clock is necessary for Kerberos:
  ensure_resource('class', 'ntp')

  if ($allowed_users_and_groups != undef) {
    class { 'epfl_sso::private::access':
      directory_source         => $directory_source,
      allowed_users_and_groups => $allowed_users_and_groups
    }
  }

  if ($enable_mkhomedir) {
    $_mkhomedir_ensure = "present"
  } else {
    $_mkhomedir_ensure = "absent"
  }
  class { 'epfl_sso::private::mkhomedir':
    ensure => $_mkhomedir_ensure
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

  if ($ad_automount_home) {
    class { "epfl_sso::private::nfs":
      debug_gssd => $debug_gssd,
    }
    class { "epfl_sso::private::ad_automount_home": }
  }
}
