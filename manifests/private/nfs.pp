# coding: utf-8
# Class: epfl_sso::nfs
#
# EPFL-specific NFSv4 configuration (client and server)
#
# === Parameters:
#
# $server_ensure::             Either "present" or "absent"
# $client_ensure::             Either "present" or "absent"
# $debug::                     A dict of debug topics as keys (value must be
#                              truthy, but is otherwise irrelevant)
#
# === Actions:
#
# * Ensure that rpc.gssd is started (if $client_ensure == "present") resp.
#   stopped (if $client_ensure is not undef)
#
# * Ensure that the binaries required for modern the idmap kernel upcall
#   mechanism are installed and configured (in /etc/idmapd.conf)
#
# * Ensure that rpc.idmapd is *not* running
#
# === Bibliography:
#
# [Durrer] "Configuration AD NFSv4 Client Ubuntu 16.04-16.10 sur AD de
# Prod et Automap Home mode LDAP", L. Durrer,
# https://sico.epfl.ch:8443/pages/viewpage.action?spaceKey=SIAC&title=IDEVING
  
class epfl_sso::private::nfs(
  $server_ensure = "present",
  $client_ensure = "present",
  $debug = {},
  $krb5_domain = $::epfl_sso::private::params::krb5_domain
) inherits epfl_sso::private::params {

  ########### rpc.gssd configuration

  anchor { "epfl_sso::private::nfs::rpc_gssd_configured": }

  if ($::operatingsystem == "Ubuntu" and
      $::operatingsystemrelease >= "16.04") {
    file_line { "NEED_GSSD in /etc/default/nfs-common":
      path => "/etc/default/nfs-common",
      ensure => present,
      line => $client_ensure ? {
        "present" => "NEED_GSSD=yes",
        default   => "NEED_GSSD="
      },
      match => "^NEED_GSSD"
    } ~> exec { "systemctl daemon-reload; systemctl restart nfs-config.service":
      path => $::path,
      refreshonly => true
    } -> Anchor["epfl_sso::private::nfs::rpc_gssd_configured"]
  }

  ensure_packages($rpc_gssd_package)
    
  Anchor["epfl_sso::private::nfs::rpc_gssd_configured"] ->
  service { "rpc-gssd":
      ensure => $client_ensure ? {
        "present" => "running",
        undef     => undef,
        default   => "stopped"
      },
      enable => $client_ensure ? {
        "present" => true,
        undef     => undef,
        default   => false
      },
      require => [Package[$rpc_gssd_package]]
  }

  ########### ID-mapping configuration
  $idmapd_conf_file = "/etc/idmapd.conf"

  # [Durrer] p. 8
  ini_setting { "[General] Domain in ${idmapd_conf_file}":
    ensure  => $client_ensure,
    path    => $idmapd_conf_file,
    section => "General",
    setting => "Domain",
    value   => $krb5_domain,
  }

  # Ibid (even though this is the default behavior)
  ini_setting { "[Translation] Method in ${idmapd_conf_file}":
    ensure  => $client_ensure,
    path    => $idmapd_conf_file,
    section => "Translation",
    setting => "Method",
    value   => "nsswitch"
  }

  if ($client_ensure == "present") {
    ensure_packages([$request_key_package, $nfsidmap_package])
    file { [$request_key_path, $nfsidmap_path]:
      ensure => "present",
      require => Package[$request_key_package, $nfsidmap_package]
    }
  }

  # On modern distros there is no longer an rpc.idmapd required;
  # instead the kernel does an "upcall" to $nfsidmap_path whenever
  # needed (see e.g.
  # https://www.kernel.org/doc/Documentation/filesystems/nfs/idmapper.txt
  # and
  # https://bugs.launchpad.net/ubuntu/+source/nfs-utils/+bug/1428961)
  service { ["idmapd", "rpc.idmapd"]:
    ensure => "stopped",
    enable => false
  }
}
