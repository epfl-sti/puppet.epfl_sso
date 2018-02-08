# Class: epfl_sso::private::sss
#
# Configure sssd and its clients for integration into SCOLDAP or Active Directory

class epfl_sso::private::sss(
  $sssd_packages      = $epfl_sso::private::params::sssd_packages,
  $sssd_cleanup_globs = $epfl_sso::private::params::sssd_cleanup_globs,
  $auth_source,
  $directory_source,
  $ad_server,
  $ad_server_base_dn,
  $debug_sssd,
  $manage_nsswitch_netgroup
) inherits epfl_sso::private::params {
  package { $sssd_packages :
    ensure => present
  } ->
  file { '/etc/sssd/sssd.conf' :
    ensure  => present,
    content => template('epfl_sso/sssd.conf.erb'),
    # The template above uses variables $debug_sssd, $auth_source,
    # $ad_server and $ad_server_base_dn
    owner   => root,
    group   => root,
    mode    => '0600'
  } ~>
  service { 'sssd':
    ensure  => running,
    enable  => true,
    restart => ["/bin/bash", "-c", "set -e -x; service sssd stop; rm ${sssd_cleanup_globs}; service sssd start"]
  }

  include epfl_sso::private::pam
  epfl_sso::private::pam::module { "sss": }

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
}
