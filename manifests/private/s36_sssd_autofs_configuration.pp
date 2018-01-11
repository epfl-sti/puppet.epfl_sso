
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
}
