# Creation du fichier realm.conf
# fait le 15 Nov 2017 , Mokhtar2107
###

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
