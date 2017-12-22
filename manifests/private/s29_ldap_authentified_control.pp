
# Class: epfl_sso::private::s29_ldap_authentified_control
#
# 29 Configuration du client LDAP en mode authentifié
#   /etc/ldap/ldap.conf
#
# === Parameters:
#
#-----------------------------------------------------------------------------------------------------------
#
# LDAP Defaults
#
# See ldap.conf(5) for details
# This file should be world readable but not world writable.
# BASE dc=example,dc=com
# URI ldap://ldap.example.com ldap://ldap-master.example.com:666
#
#
#
class epfl_sso::private::s29_ldap_authentified_control {

  file { '/etc/ldap/ldap.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template(
        '# This file is managed with Puppet.

BASE         dc=intranet,dc=epfl,dc=ch
HOST         ad1.intranet.epfl.ch ad2.intranet.epfl.ch ad3.intranet.epfl.ch ad5.intranet.epfl.ch ad6.intranet.epfl.ch
PORT         636
SASL_NOCANON on

#SIZELIMIT  12
#TIMELIMIT  15
#DEREF      never

# TLS certificates (needed for GnuTLS)
# TLS_CACERT /etc/ssl/certs/ca-certificates.crt

SSL             start_tls
TLS_CACERT      /etc/ldap/cacerts/ca-certificates.crt
TLS_CACERTDIR   /etc/ldap/cacerts
TLS_REQCERT     demand

'),

  }
include epfl_sso::private::params
include epfl_sso::private::pam

}
