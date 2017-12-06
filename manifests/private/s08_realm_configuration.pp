# Creation du fichier realm.conf
# fait le 15 Nov 2017 , Mokhtar2107
### Le fichier realm.conf  Option mais interesting for me
#  3.1.	Recréere c efichier à partir de zero
#  

# [active-directory]
# os-name = Ubuntu Linux
# os-version = 16.04

# [service]
automatic-install = yes

[users]

#default-home = /home/%u
default-shell = /bin/bash


[idevingtladf2.loc]
user-principal = yes
fully-qualified-names = no
###
# Class: epfl_sso::private::nfs_automounts
#
# This class makes automounting
class epfl_sso::private::s08_realmd_configuration () {
  file { '/etc/realmd':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0777',
    content => "# This file is managed by Puppet; DO NOT EDIT

NEED_GSSD=yes
"
  }
