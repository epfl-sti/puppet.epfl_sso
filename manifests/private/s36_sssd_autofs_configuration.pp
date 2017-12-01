
# class epfl_sso::s36_sssd_autofs_configuration
#
# There will be a mix twn : manual & automatic
#the file is existing in Puppet
# s 36 Configuration SSSD avec l’Autofs
# sudo nano /etc/sssd/sssd.conf
#
#Be careful to those lines below :
#---------------------------------
# ldap_schema = RFC2307
# ldap_sasl_mech = GSSAPI
# ldap_autofs_search_base = OU=automaps,DC=idevingtladf2,DC=loc
# ldap_autofs_map_object_class = automountMap
# ldap_autofs_map_name = automountMapName
# ldap_autofs_entry_object_class = automount
# ldap_autofs_entry_key = cn
# ldap_autofs_entry_value = automountInformation
#
#[sssd]
#services = nss, pam, autofs
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
