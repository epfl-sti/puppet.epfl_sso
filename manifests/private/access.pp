# Class: epfl_sso::private::access
#
# This class enforces access control.
#
# === Parameters:
#
# $directory_source::          Either "AD" or "scoldap"
#
# $allowed_users_and_groups::  access.conf(5)-style ACL, e.g. "user1 user2 (group1) (group2)"
class epfl_sso::private::access(
  $directory_source,
  $allowed_users_and_groups = '',
  ) {
    $_allowed_users_and_groups_2 = $allowed_users_and_groups ? {
      /\wgdm\w/  => $allowed_users_and_groups,
      default    => $::osfamily ? {
        "Debian"  => "gdm $allowed_users_and_groups",
        default   => $allowed_users_and_groups
      }
    }
    $_allowed_users_and_groups = $directory_source ? {
      "scoldap" => $_allowed_users_and_groups_2.downcase,
      default   => $_allowed_users_and_groups_2
    }
  fail($_allowed_users_and_groups)
  file { '/etc/security/access.conf':
    ensure  => present,
    content => inline_template('# This file is managed with Puppet.

- : ALL EXCEPT root <%= @_allowed_users_and_groups %> : ALL
'),
    owner   => root,
    group   => root,
    mode    => '0644'
  }
  include epfl_sso::private::pam
  epfl_sso::private::pam::module { "access": }
}
