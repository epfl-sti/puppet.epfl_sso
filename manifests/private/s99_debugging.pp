# Class: epfl_sso::private::s99_debugging
#
#
# This class shows variables .
# === Parameters:
#
/*
class debug_with_path {

  notify { 'FqdnTest':
    withpath => true,
    name     => "my fqdn is ${::fqdn}",
  }
}

# notice: /Stage[main]/Not::Base/Notify[FqdnTest]/message: my fqdn is pcbtest.udlabs.private

*/

class epfl_sso::private::s99_debugging {


  # for debug output on the puppet client
#  notify {"Running with \$mysql_server_id ${::mysql_server_id} ID defined":}

    notify { 'Fqdn':
      withpath => true,
      name     => "00 - my fqdn is ${::fqdn}",
            }

    notify { 'Fqdn.downcase':
      withpath => true,
      name     => "01 - my fqdn.downcase is ${::fqdn.downcase}",
            }

    notify { 'Server Name':
      withpath => true,
      name     => "02 - my servername is ${::servername}",
            }

    notify { 'Server IP':
      withpath => true,
      name     => "03 - my server ip ${::serverip}",
            }

    notify { 'is_dhcp':
      withpath => true,
      name     => "04 - is dhcp ${::is_dhcp}",
            }

    notify { '::networking':
      withpath => true,
      name     => "05 - is dhcp ${::networking}",
            }

    notify { '::networking[dhcp]':
      withpath => true,
      name     => "06 - is dhcp ${::networking}",
                    }

#
# $is_dhcp = ($ and $)
#




  include epfl_sso::private::params
  include epfl_sso::private::pam

}
