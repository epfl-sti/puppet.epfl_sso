#
# class epfl_sso::private::s34_mounting_check_mix_configuration
#
# s34 Check & control of the mounts with a mixt configuration
#   0 - mkdir /localhome
#   1 - move the the administrator home folder to /localhome
#   2 - copy the content of /home/administrator to /localhome/administrator
#   3 - sudo cp -r /home/administrator/   /localhome/
#   4 - change mode permissions : new-owner:new-group file
#   5 - sudo chown -R administrator:administrator     /localhome/administrator
#   6 - Asap the autofs is activated then the local /home will be hidden and UNaccessible,
#   7 - it will be then redirected to another Directory
#   8 - To Be Sure that you avoided conflicts between Local mounts vs AD :
#   9 - you must :
#          you must check all the files under /etc/auto.*
#               auto.master
#               auto.misc
#               auto.net
#               auto.smb
#               auto.home
#          comment ( add # ) for all entries configured by LDAP ; example :: /etc/auto.home

#  10 - #durrer vpsi-nfsv4-test.idevingtladf2.loc:/nas_coll_ma_vpsi_nfsv4_test_cifs_files/home/durrer
#  11 - administrator localhost:/localhome/administrator

#  12 - in thsi case - in line 11 -:
#       13 -   the account : local administrator home's directory { /home/adminisrator }
#              is redirected to /localhome/administrator


# modules/epfl_sso/manifests/private/s34_mounting_check_mix_configuration.pp


class epfl_sso::private::s34_mounting_check_mix_configuration {

# 1 - file { '/etc/auto.master':
# 2 - file { '/etc/auto.misc':
# 3 - file { '/etc/auto.net':
# 4 - file { '/etc/auto.smb':
# 5 - file { '/etc/auto.home':

      file { '/etc/auto.master':

          ensure  => present,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => inline_template ( '# auto.master : Under Construction   '),
      }

      file { '/etc/auto.misc':

          ensure  => present,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => inline_template ( '# auto.misc : Under Construction   '),
            }

      file { '/etc/auto.net':

          ensure  => present,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => inline_template ( '# auto.net : Under Construction   '),
                }
      file { '/etc/auto.smb':

          ensure  => present,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => inline_template ( '# auto.smb : Under Construction   '),
                      }

      file { '/etc/auto.home':

          ensure  => present,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => inline_template ( '# auto.home : Under Construction   '),
                          }

include epfl_sso::private::params
include epfl_sso::private::pam
}
