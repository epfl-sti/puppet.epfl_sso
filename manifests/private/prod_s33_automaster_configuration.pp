

#
# Class: epfl_sso::private::prod_s33_automaster_configuration
#
# 33 Configuration de auto.master
#   /etc/auto.master
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
#
#

class epfl_sso::private::prod_s33_automaster_configuration {

  file { '/etc/auto.master':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template(
        '# This file is managed with Puppet.

/net -hosts

#+dir:/etc/auto.master.d

+auto.master

'),

  
  }
include epfl_sso::private::params

include epfl_sso::private::pam
}
