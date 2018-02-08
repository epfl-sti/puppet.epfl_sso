# Enable automounting NFS home directories on Linux
#
# === Bibliography:
#
# [Durrer] "Configuration AD NFSv4 Client Ubuntu 16.04-16.10 sur AD de
# Prod et Automap Home mode LDAP", L. Durrer,
# https://sico.epfl.ch:8443/pages/viewpage.action?spaceKey=SIAC&title=IDEVING

class epfl_sso::private::ad_automount_home(
  $autofs_deps                = $::epfl_sso::private::params::autofs_deps,
  $autofs_service             = $::epfl_sso::private::params::autofs_service,
  $krb5_domain                = $::epfl_sso::private::params::krb5_domain,
  $ad_server_urls             = $::epfl_sso::private::params::ad_server_urls,
  $ad_server_base_dn          = $::epfl_sso::private::params::ad_server_base_dn,
  $autofs_conf_path           = $::epfl_sso::private::params::autofs_conf_path,
  $autofs_ldap_auth_conf_path = $::epfl_sso::private::params::autofs_ldap_auth_conf_path
) inherits epfl_sso::private::params {
  ensure_packages($autofs_deps)
  Package[$autofs_deps] ->
  service { $autofs_service:
    ensure    => "running",
    enable    => true,
    subscribe => [Exec["epfl_sso-msktutil"], Service["sssd"]]
  }

  # [Durrer], p. 45
  file { $autofs_conf_path:
    notify  => Service[$autofs_service],
    content => inline_template('# Managed by Puppet, DO NOT EDIT.
timeout = 300
dismount_interval = 300
ldap_uri = <%= @ad_server_urls %>
search_base = "ou=automaps,<%= @ad_server_base_dn %>"
map_object_class = "automountMap"
entry_object_class = "automount"
map_attribute = " automountMapName"
entry_attribute = "cn"
value_attribute = "automountInformation"
auth_conf_file = "<%= @autofs_ldap_auth_conf_path %>"
')
  }

  # [Durrer], p. 45
  file { $autofs_ldap_auth_conf_path:
    notify  => Service[$autofs_service],
    content => inline_template('
<?xml version="1.0" ?>
<!--
Managed by Puppet, DO NOT EDIT.

See autofs_ldap_auth.conf(5) for more information.
-->
<autofs_ldap_sasl_conf usetls="no" tlsrequired="no"
  authrequired="yes" authtype="GSSAPI" clientprinc="host/<%= @fqdn %>@<%= @krb5_domain %>"
/>
')
  }

  # [Durrer] p. 47
  name_service { 'automount':
    lookup => ['files', 'sss']
  } ~> Service["autofs"]

  # Work around https://bugs.launchpad.net/ubuntu/+source/sssd/+bug/1566508
  # on systemd-capable systems; wait for sssd to be able to answer "automount -m"
  # before running autofs for real.
  file { "/etc/systemd/system/autofs.service.d":
    ensure => "directory"
  } ->
  file { "/etc/systemd/system/autofs.service.d/wait-for-sssd.conf":
    content => inline_template('# Managed by Puppet, DO NOT EDIT
[Service]
ExecStartPre=/bin/bash -c "for time in $(seq 1 60); do if /usr/sbin/automount -m 2>&1 |grep -q setautomntent; then sleep 1; else exit 0; fi; done; exit 1"
')
  } ~>
  exec { "systemctl daemon-reload # for autofs systemd config changes":
    path => $::path,
    refreshonly => true
  } ~>
  Service["autofs"]
}
