
# class epfl_sso::s36_sssd_autofs_configuration
#
#
#
#

class epfl_sso::s36_sssd_autofs_configuration {

    package { 'nfs-common':
          ensure => present,
        }
    package { 'autofs':
          ensure => present,
        }
    package { 'autofs-ldap':
          ensure => present,
        }


    notify  { 'nfs-common':
              withpath => true,
              name     => "A - nfs-common ",
            }
    notify  { 'autofs':
              withpath => true,
              name     => "B - autofs ",
            }
    notify  { 'nfs-common':
              withpath => true,
              name     => "A - nfs-common ",
            }
    notify  { 'autofs-ldap':
              withpath => true,
              name     => "C - autofs-ldap ",
            }
}
