# coding: utf-8
# Class: epfl_sso::nfs
#
# EPFL-specific NFSv4 configuration (client and server)
#
# === Parameters:
#
# $server_ensure::             Either "present" or "absent"
# $client_ensure::             Either "present" or "absent"
# $debug_gssd::                Whether to put rpc.gssd in debug mode
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
  $server_ensure            = "present",
  $client_ensure            = "present",
  $debug_gssd               = false,
  $krb5_domain              = $::epfl_sso::private::params::krb5_domain,
  $defaults_nfs_common_path = $::epfl_sso::private::params::defaults_nfs_common_path
) inherits epfl_sso::private::params {

  ########### rpc.gssd configuration

  anchor { "epfl_sso::private::nfs::rpc_gssd_configured": }

  if ($::operatingsystem == "Ubuntu" and
      $::operatingsystemrelease >= "16.04") {
    file { $defaults_nfs_common_path:
      ensure  => 'present',
      replace => 'no', # Don't purge the file if already there
      content => "",
      mode    => '0644',
    }

    file_line { "NEED_GSSD in ${defaults_nfs_common_path}":
      path => $defaults_nfs_common_path,
      ensure => present,
      line => $client_ensure ? {
        "present" => "NEED_GSSD=yes",
        default   => "NEED_GSSD="
      },
      match => "^NEED_GSSD"
    } ~> Exec["regenerate-nfs-config"]

    if ($::has_ubuntu_bug_1023051) {
      file { "/etc/systemd/system/rpc-gssd.service.d":
        ensure => "directory"
      } ->
      file { "/etc/systemd/system/rpc-gssd.service.d/env.conf":
        content => inline_template('# Managed by Puppet, DO NOT EDIT
<% if @debug_gssd %>
[Service]
Environment="GSSDARGS=-r -r -r -v -v -v"
<% end %>
')
      } ~> Exec["regenerate-nfs-config"]
    } else {
      if ($debug_gssd) {
        $_gssdargs_ensure = "present"
      } else {
        $_gssdargs_ensure = "absent"
      }
      file_line { "RPCGSSDARGS in ${defaults_nfs_common_path}":
        path => $defaults_nfs_common_path,
        line => $_gssdargs_ensure ? {
          "present" => "RPCGSSDARGS='-r -r -r -v -v -v'",
          default   => "RPCGSSDARGS="
        },
        match => "^RPCGSSDARGS="
      } ~> Exec["regenerate-nfs-config"]
    }

    exec { "regenerate-nfs-config":
      command => "systemctl daemon-reload; systemctl restart nfs-config.service; systemctl restart rpc-gssd.service",
      path => $::path,
      refreshonly => true,
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
