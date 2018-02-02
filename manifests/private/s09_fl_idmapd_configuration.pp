
# Class: epfl_sso::private::  s09_fl_idmapd_configuration
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


class epfl_sso::private::s09_fl_idmapd_configuration {

  file { '/etc/idmapd.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template(
        '# This file is managed with Puppet.

[General]
Verbosity = 0
Pipefs-Directory = /run/rpc_pipefs
# set here your own domain here , if id difffers from FQDN minus HostName Domain = idevingtladf2.loc

[Mapping]

Nobody-User   = nobody
Nobody-Group  = nogroup

[Translation]

Method = nsswitch

'),

    }

    include epfl_sso::private::params
    include epfl_sso::private::pam
  /*   epfl_sso::private::pam::module { "access": } */
  }
