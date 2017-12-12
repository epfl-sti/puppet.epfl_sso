
#
#
# Class: epfl_sso::private::prod_s35_nsswitch_activation_conf
#
# 35 Activation de l’automount dans nsswitch.conf
#  /etc/nsswitch.conf
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
#
#

class epfl_sso::private::prod_s35_nsswitch_activation_conf {

  file { '/etc/nsswitch.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template(
        '# This file is managed with Puppet.

# /etc/nsswitch.conf
#
# Example configuration of GNU Name Service Switch functionality.
# If you have the _glibc-doc-reference_ and -info- packages installed, try
# _info libc "Name Service Switch_ for information about this file.

passwd:     compat sss
group:      compat sss
shadow:     compat sss
gshadow:    files
##hosts:    files resolve [!UNAVAIL=return] mdns4_minimal [NOTFOUND=return] dns
hosts:      files mdns4_minimal [NOTFOUND=return] dns
networks:   files
protocols:  db files
services:   db files sss
ethers:     db files
rpc:        db files
netgroup:   nis sss
sudoers:    files sss
automount:  files sss

automount:  files sss

'),

  }
include epfl_sso::private::params

include epfl_sso::private::pam
}
