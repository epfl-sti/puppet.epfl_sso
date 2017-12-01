
# class epfl_sso::s39_puppet_services_creation
#
# This class will install those services:
#     rgc.ssd .
#     idmap
# Then cheking their stop & restart
#
# === Parameters:
#
#
#

class epfl_sso::s39_puppet_services_creation {
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
