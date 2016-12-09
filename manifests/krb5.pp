# coding: utf-8
# Class: epfl_sso::krb5
#
# Integrate this computer into Kerberos
#
# This class is the translation into Puppet of
# https://fuhm.net/linux-and-active-directory/
#
# Unlike Windows, this approach does *not* preclude cloning - A number
# of VMs can share the same Kerberos credentials with no issues.
# *However*, one should *not* run this class periodically in this use
# case (or alternatively, all clones should have a different hostname)
#
# === Parameters:
#
# $join_domain:: An OU path relative to the Active Directory root, e.g.
#                "OU=STI" for a physical machine, or
#                "OU=STI,OU=StudentVDI,OU=VDI,OU=DIT-Services Communs"
#                for a student VM.
#                Undefined if we do not care about creating / maintaining
#                an object in AD. Joining the domain the first time
#                requires credentials with write access to Active Directory,
#                which can be obtained by running e.g. "kinit AD243371"
#                (for a physical machine) or "kinit itvdi-ad-sti" (for a
#                student VM) as the same user (typically root) as Puppet
#                is subsequently run as.
#
# $ad_server::   The Active Directory server to use
#
# === Actions:
#
# * Create EPFL-compatible /etc/krb5.conf
#
# * Deploy pam_krb5.so in an "opportunistic" configuration: grab a TGT if we can,
#   but fail gracefully otherwise
#
# * Optionally (depending on $join_domain), create or update Active
#   Directory-compatible credentials in /etc/krb5.keytab . Note that cloning
#   virtual machines that are registered in the domain suffers from the same
#   kind of issues as on the Windows platform; as each VM instance will try
#   to update the Kerberos password for the AD entry, they will quickly diverge
#   since only one of them will succeed to do so.

class epfl_sso::krb5(
  $ad_server = "ad3.intranet.epfl.ch",
  $join_domain = undef
) {
  if ($::epfl_krb5_resolved == "false") {
    fail("Unable to resolve KDC in DNS – You must use the EPFL DNS servers.")
  }

  # TODO: this is Debian-ish only
  $packages = [ "krb5-user", "libpam-krb5", "msktutil", "dnsutils" ]
  ensure_packages($packages)

  if (! $::epfl_krb5_resolved) {
    Package["dnsutils"] ~>
    exec { "echo 'dig was installed - Please run Puppet again'; exit 2":
      path => $::path,
      refreshonly => true
    }
  }

  if ($join_domain) {
    exec { "Join Active Directory domain":
      path => $::path,
      command => "/bin/echo 'mkstutil -c failed - Please run kinit <ADSciper or \"itvdi-ad-sti\"> first'; false",
      unless => "msktutil -c --server ${ad_server} -b '${join_domain}' --no-reverse-lookups --computer-name ${::hostname}",
      require => [Package[$packages], File["/etc/krb5.conf"]]
    }
  }

  file { "/etc/krb5.conf":
    content => template("epfl_sso/krb5.conf.erb")
  }

  file { "/etc/idmapd.conf":
    content => template("epfl_sso/idmapd.conf.erb")
  }

  file { "/etc/default/nfs-common":
    content => template("epfl_sso/nfs-common.erb")
  }

  case $::osfamily {
    'RedHat': {
        $pam_classes = {
               'auth' =>  {
                   'krb5 auth in system-auth' => { service => 'system-auth'},
                   'krb5 auth in password-auth' => { service => 'password-auth'}
               },
               'account' =>  {
                   'krb5 account in system-auth' => { service => 'system-auth'},
                   'krb5 account in password-auth' => { service => 'password-auth'}
               },
               'password' =>  {
                   'krb5 password in system-auth' => { service => 'system-auth'},
                   'krb5 password in password-auth' => { service => 'password-auth'}
               },
               'session' =>  {
                   'krb5 session in system-auth' => { service => 'system-auth'},
                   'krb5 session in password-auth' => { service => 'password-auth'}
               },
        }
     }
     'Debian': {
        $pam_classes = {
               'auth' =>  {
                   'krb5 auth in common-auth' => { service => 'common-auth'},
               },
               'account' =>  {
                   'krb5 account in common-account' => { service => 'common-account'}
               },
               'password' =>  {
                   'krb5 password in common-password' => { service => 'common-password'}
               },
               'session' =>  {
                   'krb5 session in common-session' => { service => 'common-session'},
                   'krb5 session in common-session-noninteractive' => { service => 'common-session-noninteractive'}
               },
        }
    }
  }
  create_resources(pam, $pam_classes['auth'],
    { 
      ensure => present,
      type => 'auth',
      control => '[success=ok default=ignore]',
      module => 'pam_krb5.so',
      arguments => 'try_first_pass'
    })
  create_resources(pam, $pam_classes['account'],
    { 
      ensure => present,
      type => 'account',
      control => '[success=ok default=ignore]',
      module => 'pam_krb5.so',
  })
  # No changing password over Kerberos – Use sss.
  create_resources(pam, $pam_classes['session'],
    { 
      ensure => present,
      type => 'session',
      control => 'optional',
      module => 'pam_krb5.so',
  })
}
