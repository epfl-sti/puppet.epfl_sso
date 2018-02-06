
# Class: epfl_sso::private::prod_s07_install_few_packages
#
# This class will install few packages listed .
#class packages {
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
# nfs-common,
# autofs,
# autofs-ldap
#
#

class epfl_sso::private::s07_install_and_run_nfs_and_autofs {

notify {" Here starts S07'; hello world ${var1}":}

      package { 'nfs-common'  : ensure => 'latest' }
      package { 'autofs'      : ensure => 'latest' }
      package { 'autofs-ldap' : ensure => 'latest' }

      service { 'autofs':
          ensure     => running,
          enable     => true,
          hasrestart => true,
          hasstatus  => true,
              }

}
