
# class epfl_sso::private::s36_sssd_autofs_configuration {
#
#
#

class epfl_sso::private::s36_sssd_autofs_configuration {

    notify  { 'nfs-common':
              withpath => true,
              name     => 'A - nfs-common ',
            }
    notify  { 'autofs':
              withpath => true,
              name     => 'B - autofs ',
            }

    notify  { 'autofs-ldap':
              withpath => true,
              name     => 'C - autofs-ldap ',
            }
}
