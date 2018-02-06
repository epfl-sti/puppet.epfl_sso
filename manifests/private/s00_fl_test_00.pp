

# Example: to make sure that your ssh server does not allow password-based user login:
# then top add a line in that file : ssh/sshd_config

class epfl_sso::private::s00_fl_test_00 {


  file_line {'disable password login':
      ensure => 'absent',
      line   => 'PasswordAuthentication yes',
      path   => '/etc/ssh/sshd_config',
            }

  file      { '/etc/ssh/sshd_config':

      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template  (
        '# This file / line is CHECKED with Puppet.
                                  '),
            }

    include epfl_sso::private::params
    include epfl_sso::private::pam


  }
