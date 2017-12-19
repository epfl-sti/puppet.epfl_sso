class epfl_sso::private::nfs::params inherits epfl_sso::private::params {
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
