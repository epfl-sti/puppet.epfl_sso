
# Class: epfl_sso::private::s06b_ntp_config.pp
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

# == Class: ntp::config
class ntp::config inherits ntp {

  file { '/etc/ntp.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template($module_name/ntp.conf.erb),
  }

}
