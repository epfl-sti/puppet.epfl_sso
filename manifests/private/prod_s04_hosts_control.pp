
#
# Class: epfl_sso::private::prod_s04_hosts_control
#
# This class will modify hosts file
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
#
#


class epfl_sso::private::prod_s04_hosts_control {

  file { '/etc/hosts':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template(
        '# This file is managed with Puppet.

            127.0.0.1 localhost
            127.0.1.1 ditsbpc17l9.intranet.epfl.ch ditsbpc17l9
            # The following lines are desirable for IPv6 capable hosts
            ::1 ip6-localhost ip6-loopback
            fe00::0 ip6-localnet
            ff00::0 ip6-mcastprefix
            ff02::1 ip6-allnodes
            ff02::2 ip6-allrouters

'),

    }
    include epfl_sso::private::params
    include epfl_sso::private::pam

  }
