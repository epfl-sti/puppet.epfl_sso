
# Class: epfl_sso::private::s06c_ntp_service.pp
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

# == Class: ntp::service
class ntp::service inherits ntp {

  service { 'ntp':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require => Package['ntp'],
  }

}
