
# Class: epfl_sso::private::s06a_ntp_installation
#
# This class will install ntp service ,
# also check next time if the version is latest !!!
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
#   class epfl_sso::private::s06a_ntp_installation {

# == Class: ntp::install


class epfl_sso::private::s06a_ntp_installation inherits ntp {

  package { 'ntp':
    ensure => installed,
  }

}
