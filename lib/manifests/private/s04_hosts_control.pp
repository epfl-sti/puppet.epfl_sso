
# Class: epfl_sso::private::s07_install_few_packages
#
# This class will install few packages listed .
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

class epfl_sso::s04_hosts_control {
    package { 'nfs-common':
          ensure => present,
        }
    package { 'autofs':
          ensure => present,
        }
    package { 'autofs-ldap':
          ensure => present,
        }
}
