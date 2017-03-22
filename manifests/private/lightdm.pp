#
# Show manual login in latest ubuntu in case where the display manager is lightDM
#
class { "epfl_sso::private::lightdm"}:
  case $::osfamily {
    'Debian': {
      if ($::operatingsystemrelease in ['15.04', '15.10', '16.04', '16.10'] and $::operatingsystem == 'Ubuntu') {
        if (str2bool($::is_lightdm_active)) {
          file { "/etc/lightdm/lightdm.conf.d" :
            ensure => directory
          }
          file { "/etc/lightdm/lightdm.conf.d/50-show-manual-login.conf" :
            content => inline_template("#
# Managed by Puppet, DO NOT EDIT
# /etc/puppet/modules/epfl_sso/manifests/init.pp
#
[Seat:*]
greeter-show-manual-login=true
")
          }~>service { "lightdm" :
            ensure => running # Restart lightdm if the 50-show-manual-login.conf file changes
          }
        }
      } else {
        notify {"Enabling the manual greeter on version $::operatingsystemrelease of Ubuntu is not supported. Please check https://github.com/epfl-sti/puppet.epfl_sso":}
      }
    }
  }
}
