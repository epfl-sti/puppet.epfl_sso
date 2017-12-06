
# Class: epfl_sso::private::s09_idmapd_configuration
#
# This class will install few packages listed .
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated

#  2.	Le fichier /etc/ldap/ldap.conf

 #  2.1.    La donnée BASE doit être une nouvelle variable dans Params.pp elle sera
 #          concaténée pour ce resultat : dc=idevingtladf2, dc=loc
 #  2.2.	Il faudra créer une autre variable pour récupérer :
 #        le chemin de  “/etc/ldap/certs/ca-certificates.cet” en fonction de la distribution ;
 #        Ubuntu-Debian ou RedHat
 #  2.3.	Il y a une autre difficulté pour ajouter des lignes à un fichier existant
 #        avec la commande puppet  infile
 #  3.
#  # $allowed_users_and_groups::  access.conf(5)-style ACL, e.g. "user1 user2 (group1) (group2)"
#  #  class epfl_sso::private::access(
#  #    $allowed_users_and_groups = '',
#  #    ) {
/*$ad_server = "ad3.intranet.epfl.ch"
}
$use_test_ad = ($ad_server =~ /idevingtladf2.loc/)
$realm = $use_test_ad ? {
*/


class epfl_sso::private::s09_idmapd_configuration {

  file { '/etc/security/idmapd.conf':
      ensure  => present,
      content => inline_template(
        '# This file is managed with Puppet.

        {General}

        Verbosity = 0
        Pipefs-Directory = /run/rpc_pipefs
        # set here your own domain here , if id difffers from FQDN minus HostName Domain = idevingtladf2.loc

        Domain                  = <%= @ad_server  %>
        Realm                   = <%= @realmd  %>
        is_puppet_apply         = <%= @is_puppet_apply  %>
        servername              = <%= @servername  %>
        osfamily                = <%= @osfamily  %>
        operatingsystem         = <%= @operatingsystem  %>
        operatingsystemrelease  = <%= @operatingsystemrelease  %>
        ad_server               = <%= @ad_server  %>
        use_test_ad             = <%= @use_test_ad  %>

        {Mapping}

        Nobody-User   = nobody
        Nobody-Group  = nogroup

        {Translation}

        Methode = nsswitch

  #- : ALL EXCEPT root <%= @allowed_users_and_groups %> : ALL
   '),
      owner   => root,
      group   => root,
      mode    => '0644'
    }
    include epfl_sso::private::params
    /* epfl_sso::private::params::module { "access": } */

    include epfl_sso::private::pam
  /*   epfl_sso::private::pam::module { "access": } */
  }
