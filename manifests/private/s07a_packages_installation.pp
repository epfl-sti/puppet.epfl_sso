
# Class: epfl_sso::private::s07_install_few_packages
#
# This class will install few packages listed .
#class packages {
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
# nfs-common,
# autofs,
# autofs-ldap
#
#

class epfl_sso::s07_packages_installation {

    package { 'nfs-common'  : ensure => 'installed' }
    package { 'autofs'      : ensure => 'installed' }
    package { 'autofs-ldap' : ensure => 'installed' }
}
