
# Class: epfl_sso::private::31 Configuration de l’authentification LDAP pour l’AutoFs
#   /etc/autofs_ldap_auth.conf
#
# This class will install few packages listed .
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
#  - : ALL EXCEPT root <%= @allowed_users_and_groups %> : ALL
#

class epfl_sso::private::prod_s31_ldap_authent_autofs_configuration {

  file { '/etc/autofs_ldap_auth.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template(
        '# This file is managed with Puppet.


Veuillez mettre le nom correspondant à la machine dans l’entrée : clientprinc
----------------------------------------------------------------------------------------------------------------------
<?xml version="1.0" ?>
<!--
This files contains a single entry with multiple attributes tied to it.
See autofs_ldap_auth.conf(5) for more information.
-->
<autofs_ldap_sasl_conf
usetls         = "no"
tlsrequired    = "no"
authrequired   = "yes"
authtype       = "GSSAPI"
clientprinc    = "host/<%= @hostname %>.intranet.epfl.ch@INTRANET.EPFL.CH"
/>


'),

  }

include epfl_sso::private::params


include epfl_sso::private::pam

}
