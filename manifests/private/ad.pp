# Class: epfl_sso::private::ad
#
# Integrate this computer into EPFL's Active Directory
#
# This class is the translation into Puppet of
# https://fuhm.net/linux-and-active-directory/
#
# Unlike Windows, this approach does *not* preclude cloning - A number
# of VMs can share the same Kerberos credentials with no issues,
# provided $renew_domain_credentials is set to false (or
# alternatively, all clones should have a different hostname)
#
# === Parameters:
#
# $join_domain:: An OU path relative to the Active Directory root,
#                e.g. "OU=IEL-GE-Servers,OU=IEL-GE,OU=IEL,OU=STI" for
#                a physical machine, or
#                "OU=STI,OU=StudentVDI,OU=VDI,OU=DIT-Services Communs"
#                for a student VM. Undefined if we do not care about
#                creating / maintaining an object in AD. Joining the
#                domain the first time requires credentials with write
#                access to Active Directory, which can be obtained by
#                running e.g. "kinit AD243371" (for a physical
#                machine) or "kinit itvdi-ad-sti" (for a student VM)
#                as the same user (typically root) as Puppet is
#                subsequently run as.
#
# $manage_samba_secrets::  Whether to pass --set-samba-secret to msktutil.
#                          Requires a working, properly configured Samba
#                          installation.
#
# $renew_domain_credentials:: Whether to periodically renew the
#                Kerberos keytab entry. Has no effect under "puppet
#                agent"; RECOMMENDED for "puppet apply" unless this
#                machine is a clonable master that shares the same
#                host name with a number of clones.
#
# $ad_server::   The Active Directory server to use
#
# $realm::       
#
# $epflca_cert_url:: Where to find the certificate for the EPFL CA
#                (necessary for ldapsearch to work)
#
# === Actions:
#
# * Create EPFL-compatible /etc/krb5.conf
#
# * Set GSSAPIAuthentication to 'yes' in /etc/ssh/ssh_config
#
# * Deploy pam_krb5.so in an "opportunistic" configuration: grab a TGT
#   if we can, but fail gracefully otherwise
#
# * Entrust the EPFL-CA with OpenLDAP clients
#
# * Add suitable entries to /etc/hosts for ad{1,2,3}.{intranet.,}epfl.ch
#
# * Optionally (depending on $join_domain), create or update Active
#   Directory-compatible credentials in /etc/krb5.keytab . Note that cloning
#   virtual machines that are registered in the domain suffers from the same
#   kind of issues as on the Windows platform; as each VM instance will try
#   to update the Kerberos password for the AD entry, they will quickly diverge
#   since only one of them will succeed to do so.
#
# * If running "puppet apply", and if both $join_domain and
#   $renew_domain_credentials are true, set up a crontab to renew the
#   keytab daily

class epfl_sso::private::ad(
  $ad_server,
  $realm,
  $use_test_ad,
  $join_domain,
  $manage_samba_secrets = $epfl_sso::private::params::manage_samba_secrets,
  $epflca_cert_url = 'http://certauth.epfl.ch/epflca.cer',
  $renew_domain_credentials = true,
) inherits epfl_sso::private::params {
  # Kerberos servers who would like to identify their peer using a
  # reverse DNS are in for a surprise for some of the hosts... Among
  # which, the AD servers themselves :(
  define etchosts_line($ip) {
    host { "${title}.${::epfl_sso::private::ad::realm}":
      host_aliases => $title,
      ip => $ip,
      ensure => "present"
    }
  }

  if ($use_test_ad) {
    epfl_sso::private::ad::etchosts_line { "idevingtladdc2": ip => "128.178.109.26" }
  } else {
    epfl_sso::private::ad::etchosts_line { "ad1": ip => "128.178.15.227" }
    epfl_sso::private::ad::etchosts_line { "ad2": ip => "128.178.15.228" }
    epfl_sso::private::ad::etchosts_line { "ad3": ip => "128.178.15.229" }
    epfl_sso::private::ad::etchosts_line { "ad4": ip => "128.178.15.230" }
    epfl_sso::private::ad::etchosts_line { "ad5": ip => "128.178.15.231" }
    epfl_sso::private::ad::etchosts_line { "ad6": ip => "128.178.15.232" }
  }

  include epfl_sso::private::ldap
  epfl_sso::private::ldap::trusted_ca_cert { 'epfl':
    url => $epflca_cert_url,
    ensure => 'present'
  }

  class { "epfl_sso::private::gssapi": }

  case $::kernel {
    'Darwin': {
      notice("Mac OS X detected - Skip setup of Active Directory users, groups and authentication")
    }
    'Linux': {
      case $::osfamily {
        "Debian": {
          ensure_packages([ "krb5-user", "libpam-krb5"])
        }
        "RedHat": {
          # https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Managing_Smart_Cards/installing-kerberos.html
          ensure_packages(["krb5-workstation", "krb5-libs", "pam_krb5"])
        }
        default: {
          fail("Not sure how to install Kerberos client-side support on ${::osfamily}-family Linux")
        }
      }

      if ($join_domain) {
        ensure_packages("msktutil")
        case $::msktutil_version {
          "0.5.2", "not_installed", undef: {
            # Le sigh. https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=820579
            # undef and "not_installed" are abundance-of-caution cases, if we
            # are just installing it now or if the fact is not working.
            $_msktutil_verbose = ""
          }
          default: {
            $_msktutil_verbose = "--verbose"
          }
        }

        if ($manage_samba_secrets) {
          $_set_samba_secret_flag = "--set-samba-secret"
          $_check_ads_testjoin = true
        } else {
          $_set_samba_secret_flag = ""
          $_check_ads_testjoin = false
        }

        $_msktutil_create_command = inline_template("msktutil ${_msktutil_verbose} -c --server <%= @ad_server %> -b '<%= @join_domain %>' --no-reverse-lookups --enctypes 24 --computer-name <%= @hostname.upcase %> --service host/<%= @fqdn.downcase %> <%= @_set_samba_secret_flag %>")
        $_msktutil_renew_command = inline_template("msktutil ${_msktutil_verbose} --auto-update --enctypes 24 --computer-name <%= @hostname.upcase %> <%= @_set_samba_secret_flag %>")
        exec { $_msktutil_create_command:
          path => $::path,
          command => "/bin/echo 'msktutil -c failed - Please run kinit <ADSciper or \"itvdi-ad-YOURSCHOOL\"> first'; false",
          unless => $_msktutil_renew_command,
          require => [Package["msktutil"], File["/etc/krb5.conf"]]
        }

        if ($renew_domain_credentials and
            $epfl_sso::private::params::is_puppet_apply) {
          package { "moreutils":
            ensure => "installed"  # For the chronic command
          } ->
          file { "/etc/cron.daily/renew-AD-credentials":
            mode => "0755",
            content => inline_template("#!/bin/sh
# Renew keytab, lest Active Directory forget about us after 90 days
#
# Managed by Puppet, DO NOT EDIT

chronic <%= @_msktutil_renew_command %>
<% if @_check_ads_testjoin %>
# Also send email if the following doesn't work:
chronic net ads testjoin
<% end %>
")
          }
          file { "/etc/cron.daily/renew-AD-keytab":
            ensure => "absent"  # Former name of renew-AD-credentials
          }
        }
      }
    }
    default: {
      fail("Unsupported operating system: ${::kernel}")
    }
  }
}
