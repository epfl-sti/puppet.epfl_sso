
#  32 Configuration d’Autofs
#  Afin de simplifier le changement, vous trouverez les entrées à modifier si dessous
#   /etc/autofs.conf
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
#
class epfl_sso::private::s32_autofs_configuration {

  file { '/etc/autofs.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template(
        '# This file is managed with Puppet.

##master_map_name           = /etc/auto.master
timeout                     = 300
# browse_mode               = no
#mount_nfs_default_protocol = 3
ldap_uri                    = “ldaps://ad1.intranet.epfl.ch” “ldaps://ad2.intranet.epfl.ch” “ldaps://ad3.intranet.epfl.ch” “ldaps://ad5.intranet.epfl.ch” “ldaps://ad6.intranet.epfl.ch”
search_base                 = "ou=automaps,dc=intranet,dc=epfl,dc=ch"
map_object_class            = "automountMap"
entry_object_class          = "automount"
map_attribute               = " automountMapName"
entry_attribute             = "cn"
value_attribute             = "automountInformation"
auth_conf_file              = "/etc/autofs_ldap_auth.conf"
dismount_interval           = 300

'),

  }
include epfl_sso::private::params
include epfl_sso::private::pam

}
