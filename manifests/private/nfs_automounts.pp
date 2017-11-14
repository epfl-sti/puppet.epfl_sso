# Class: epfl_sso::private::mkhomedir
#
# Automatically create home directories upon login of a new user
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
