

#
# Class: epfl_sso::private::s37_automaster_configuration
#
# 37 Configuration SSSD avec l’Autofs
#  /etc/sssd/sssd.conf

# 33 Configuration de auto.master
#   etc/sssd/sssd.conf
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
#
#


class epfl_sso::private::s37_sssd_autofs_configuration {


  file { "/etc/sssd/":
        ensure  => "directory",
        owner   => 'root',
        mode    => '0755',
        }

  file { '/etc/sssd/sssd.config':
      ensure  => file,
      force   =>  yes,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => inline_template(
        '# This file is managed with Puppet.

        [domain/intranet.epfl.ch]

        enumerate                       = false
        ad_domain                       = intranet.epfl.ch
        krb5_realm                      = INTRANET.EPFL.ch
        realmd_tags                     = manages-system joined-with-samba
        cache_credentials               = True
        ldap_schema                     = RFC2307
        id_provider                     = ad
        krb5_store_password_if_offline  = True
        default_shell                   = /bin/bash
        ldap_id_mapping                 = True
        use_fully_qualified_names       = True
            # debug_level                  = 9
        fallback_homedir                = /home/%u
        access_provider                 = simple

        krb5_lifetime                   = 9h
        krb5_renewable_lifetime         = 6d
        krb5_renew_interval             = 60s

        ldap_sasl_mech                  = GSSAPI
            #override_homedir               = /home/%u
        ldap_autofs_search_base         = OU=automaps,DC=intranet,DC=epfl,DC=ch
        ldap_autofs_map_object_class    = automountMap
        ldap_autofs_map_name            = automountMapName
        ldap_autofs_entry_object_class  = automount
        ldap_autofs_entry_key           = cn
        ldap_autofs_entry_value         = automountInformation
        autofs_provider                 = ad

        [sssd]
        services                        = nss, pam, autofs
        config_file_version             = 2
        domains                         = intranet.epfl.ch
        default_domain_suffix           = intranet.epfl.ch

        [nss]
        filter_groups                   = root
        filter_users                    = root

        # [autofs]



'),

  }
include epfl_sso::private::params

include epfl_sso::private::pam
}
