
# Class: epfl_sso::private::s00_notice_configuration_idmapd_configuration
#
# This class will " Notice" and inFile the contete of $variables .. .
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated




class epfl_sso::private::s00_notice_configuration {

  file { '/etc/puppet/tmp/s00_notice_configuration.conf':
      ensure  => present,
      content => inline_template(
        '# This file is managed with Puppet.

Here I try to print out all the content inside variables to handle them later,
concatenate and so on.

        Domain                  = <%= @ad_server  %>
        Realm                   = <%= @realmd  %>
        is_puppet_apply         = <%= @is_puppet_apply  %>
        servername              = <%= @servername  %>
        osfamily                = <%= @osfamily  %>
        operatingsystem         = <%= @operatingsystem  %>
        operatingsystemrelease  = <%= @operatingsystemrelease  %>
        ad_server               = <%= @ad_server  %>


  #- : ALL EXCEPT root <%= @allowed_users_and_groups %> : ALL
   '),
      owner   => root,
      group   => root,
      mode    => '0644'
    }

    include epfl_sso::private::params
    include epfl_sso::private::pam

  }
