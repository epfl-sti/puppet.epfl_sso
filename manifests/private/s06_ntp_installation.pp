
# Class: epfl_sso::private::s04_ntp_installation
#
# This class will install ntp service ,
# also check next time if the version is latest !!!
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
#
#
#

class epfl_sso::s04_ntp_installation {

  package { 'ntp'  : ensure => 'installed'  }
  package { 'ntp'  : ensure => 'latest'     }
}
