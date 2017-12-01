# Class: epfl_sso::private::nfs_automounts
#
# This class makes automounting
class epfl_sso::private::nfs_automounts() {
  file { '/etc/default/nfs-common':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0777',
    content => "# This file is managed by Puppet; DO NOT EDIT
    NEED_GSSD=yes
"
      }
}
