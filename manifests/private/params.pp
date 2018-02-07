class epfl_sso::private::params {
  $krb5_domain = "INTRANET.EPFL.CH"
  if ("${::epfl_krb5_resolved}" != "true") {
    fail("Couldn't resolve the Kerberos domain controller for ${krb5_domain} - Something might be wrong with your DNS server settings")
  }
  $ad_server = "ad3.intranet.epfl.ch"
  $realm = "intranet.epfl.ch"

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

  $is_dhcp = ($::networking and $::networking[dhcp])

  if (! $is_dhcp) {
    $ensure_gssapi_server = "fixed-ip"
  } elsif ($::domain == "intranet.epfl.ch") {
    $ensure_gssapi_server = "dhcp"
  } else {
    $ensure_gssapi_server = undef
  }

  $manage_samba_secrets = any2bool($::has_net_changesecretpw)
  case $::osfamily {
    "Debian": {
      $rpc_gssd_package = "nfs-common"
      $request_key_path = "/sbin/request-key"
      $nfsidmap_path = "/usr/sbin/nfsidmap"
      $request_key_package = "keyutils"
      $nfsidmap_package = "nfs-common"
    }
    "RedHat": {
      $rpc_gssd_package = "nfs-utils"
      $request_key_path = "/usr/sbin/request-key"
      $nfsidmap_path = "/usr/sbin/nfsidmap"
      $request_key_package = "keyutils"
      $nfsidmap_package = "nfs-utils"
    }
  }
}
