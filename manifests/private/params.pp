class epfl_sso::private::params {
  $krb5_domain = "INTRANET.EPFL.CH"
  if ("${::epfl_test_krb5_resolved}" == "true") {
    $ad_server = "idevingtladdc2.idevingtladf2.loc"
  } elsif ("${::epfl_krb5_resolved}" == "true") {
    $ad_server = "ad3.intranet.epfl.ch"
  }
  $use_test_ad = ($ad_server =~ /idevingtladf2.loc/)
  $realm = $use_test_ad ? {
    true  => "idevingtladf2.loc",
    false => "intranet.epfl.ch"
  }

# We will add a varable here to concatenate fqdn  "idevingtladf2.loc"

  $is_puppet_apply = !(defined('$::servername') and $::servername)

  case "${::operatingsystem} ${::operatingsystemrelease}" {
         'Ubuntu 12.04': {
           $sssd_packages = ['sssd']
           $needs_nscd = true
         }
         default: {
           $sssd_packages = ['sssd', 'sssd-ldap']
           $needs_nscd = false
         }
  }

  case $::osfamily {
    'Debian': {
      $pam_modules_managed_by_distro = ["krb5", "mkhomedir", "sss", "winbind" ]
    }
  }

  $krb5_conf_file = $::osfamily ? {
    "Darwin" => "/private/etc/krb5.conf",
    default  => "/etc/krb5.conf"
  }
}
