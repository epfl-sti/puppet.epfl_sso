# Class: epfl_sso::private::mkhomedir
#
# Automatically create home directories upon login of a new user
class epfl_sso::private::mkhomedir() {
  case $::osfamily {
    'RedHat': {
      $_pam_mkhomedir_package = 'oddjob-mkhomedir'
    }
    'Debian': {
      case "${::operatingsystem} ${::operatingsystemmajrelease}" {
         'Ubuntu 16.04': {
              # http://packages.ubuntu.com/search?suite=xenial&keywords=oddjob-mkhomedir
           $_pam_mkhomedir_package = 'oddjob-mkhomedir'
         }
         default: {
           $_pam_mkhomedir_package = 'libpam-modules'
         }
      }
    }
  }

  package { $_pam_mkhomedir_package :
    ensure => present
  }
  include epfl_sso::private::pam
  epfl_sso::private::pam::module { "mkhomedir": }
}
