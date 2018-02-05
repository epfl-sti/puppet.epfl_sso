
# View all the puppet variables on this client

#  class epfl_sso::private::s00_all_facters_file
#
## "inlineepp("<%= @fssize + 1 %>")" and my test case passed.
#




class epfl_sso::private::s00_all_facters_file {

  file { '/etc/puppet/tmp/s00_all_facters_file.yaml':
    content => "inlineepp('<%= scope.to_hash.reject { |k,v| !( k.is_a?(String) && v.is_a?(String) ) }.s00_all_facters_file.yaml %>')"

      '# This file is managed with Puppet.

    Here I try to print out all the content inside variables to handle them later,
    concatenate and so on.


      Domain_Exec             =
      Realm                   = <%= @realmd  %>
      is_puppet_apply         = <%= @is_puppet_apply  %>

      servername_Exec         =
      osfamily                = <%= @osfamily  %>
      operatingsystem         = <%= @operatingsystem  %>
      operatingsystemrelease  = <%= @operatingsystemrelease  %>
      ad_server               = <%= @ad_server  %>


    #- : ALL EXCEPT root <%= @allowed_users_and_groups %> : ALL
    '),
  }

}
