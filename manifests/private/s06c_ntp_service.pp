
# Class: epfl_sso::private::s06c_ntp_service.pp
#
# This class will install ntp service ,
# also check next time if the version is latest !!!
#
# === Parameters:
#
#   #   class epfl_sso::private::s06c_ntp_service {
#

# == Class: ntp::service


class epfl_sso::private::s06c_ntp_service  inherits ntp {

  service { 'ntp':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['ntp'],
  }

}
