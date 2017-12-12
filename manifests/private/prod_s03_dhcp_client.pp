
# Class: epfl_sso::private::prod_s03_dhcp_client
#
# This class will install few packages listed .
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
#
#


class epfl_sso::private::prod_s03_dhcp_client {

  file { '/etc/network/interfaces':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template(

      '# This file is managed with Puppet.

      [  # interfaces(5) file used by ifup(8) and ifdown(8)

      auto lo
      iface lo inet loopback

'),
        
    }
    include epfl_sso::private::params
    include epfl_sso::private::pam

  }
