# coding: utf-8
# Class: epfl_sso
#
# This class describes integrating a Linux computer into the EPFL
# directory services (LDAP and Kerberos)
#
# === Parameters:
#
# $allowed_users_and_groups::  access.conf(5)-style ACL, e.g.
#                              "user1 user2 (group1) (group2)"
#                              Note: if you run gdm, user gdm must have access
#
# $manage_nsswitch_netgroup::  Whether to manage the netgroup entry in
#                              nsswitch.conf
#
# $enable_mkhomedir::          Whether to automatically create users' home
#                              directories upon first login
#
# $home_automounts::           Whether to use the auto.home automount map
#                              from Active Directory. Requires
#                              $directory_source == "AD"; mutually exclusive
#                              with $enable_mkhomedir. Set this to false
#                              either if the homes are to be local, or the
#                              automount map is managed by some other
#                              mechanism.
#
# $needs_nscd::                Whether to install nscd to serve as a second
#                              layer of cache (for old distros with slow sssd)
#
# $auth_source::               Either "AD" or "scoldap"
#
# $directory_source::          Either "AD" or "scoldap"
#
# $join_domain:: An OU path relative to the Active Directory root,
#                e.g. "OU=IEL-GE-Servers,OU=IEL-GE,OU=IEL,OU=STI" for
#                a physical machine, or
#                "OU=STI,OU=StudentVDI,OU=VDI,OU=DIT-Services Communs"
#                for a student VM. Undefined if we do not care about
#                creating / maintaining an object in AD (which precludes
#                $directory_source = "ad"). Joining the
#                domain the first time requires credentials with write
#                access to Active Directory, which can be obtained by
#                running e.g. "kinit AD243371" (for a physical
#                machine) or "kinit itvdi-ad-sti" (for a student VM)
#                as the same user (typically root) as Puppet is
#                subsequently run as.
#
# $renew_domain_credentials:: Whether to periodically renew the
#                Kerberos keytab entry. RECOMMENDED unless this
#                machine is a clonable master that shares the same
#                host name with a number of clones. Ignored if
#                $join_domain is not true.
#
# $sshd_gssapi_auth::    Set to true to allow inbound ssh access with
#                        Kerberos authentication. See epfl_sso::private::sshd
#                        for the required client-side configuration
#
# $debug_sssd::          Turn extra debugging on in sssd if true
#
# === Actions:
#
# Unless otherwise stated, all actions are for the Linux platform only.
#
# * (Linux if either $auth_source or $directory_source is "AD", *and*
#   Mac OS X unconditionally) Set up client configuration for Active
#   Directory's Kerberos (krb5.conf) and LDAP (SSL certificates)
#
# * Install SSSD and configure it to access directory data (nsswitch)
#   and for authentication data (PAM) from either scoldap.epfl.ch or
#   Active Directory, depending on the respective settings of
#   $directory_source and $auth_source
#
# * Ensure that customarily used login shells at EPFL are installed,
#   and optionally set up an Access Control List (ACL) based on
#   pam_access (SSSD's similar feature is not used)
#
# * Configure sshd for inbound Kerberos authentication (if
#   $sshd_gssapi_auth is true, which by default it isn't)
# 
class epfl_sso(
  $allowed_users_and_groups = undef,
  $manage_nsswitch_netgroup = true,
  $enable_mkhomedir = undef,
  $home_automounts = false,
  $auth_source = "AD",
  $directory_source = "scoldap",
  $needs_nscd = $::epfl_sso::private::params::needs_nscd,
  $ad_server = $epfl_sso::private::params::ad_server,
  $realm = $epfl_sso::private::params::realm,
  $join_domain = undef,
  $renew_domain_credentials = true,
  $sshd_gssapi_auth = undef,
  $debug_sssd = undef
) inherits epfl_sso::private::params {
  if ( (versioncmp($::puppetversion, '3') < 0) or
       (versioncmp($::puppetversion, '6') > 0) ) {
    fail("Need version 3.x thru 5.x of Puppet.")
  }

  assert_bool($manage_nsswitch_netgroup)
  if ($allowed_users_and_groups != undef) {
    assert_string($allowed_users_and_groups)
  }

  if ($enable_mkhomedir != undef) {
    if ($enable_mkhomedir and $home_automounts) {
      fail('$enable_mkhomedir and $home_automounts are incompatible with each other!')
    }
    $_do_enable_mkhomedir = $enable_mkhomedir
  } else {
    $_do_enable_mkhomedir = ($directory_source != "AD")
  }

  if ($manage_auto_home and $directory_source != "AD") {
    fail('$manage_auto_home requires $directory_source == "AD"')
  }

  if (($join_domain == undef) and ($directory_source == "AD")) {
    warn("In order to be an Active Directory LDAP client, one must join the domain (obtain a Kerberos keytab). Consider passing the $join_domain parameter to the epfl_sso class")
  }

  case $::kernel {
    'Darwin': {
      if ($join_domain) {
        fail("Joining Active Directory domain on Mac OS X is not supported")
      }
      if ($enable_mkhomedir) {
        fail("mkhomedir is not supported on Mac OS X")
      }
      if ($home_automounts) {
        fail("Home automounts are not supported on Mac OS X")
      }
      class { "epfl_sso::private::ad":
        join_domain => false,
        ad_server   => $ad_server
      }
    }
    'Linux': {
      class { "epfl_sso::private::init_linux":
        allowed_users_and_groups => $allowed_users_and_groups,
        manage_nsswitch_netgroup => $manage_nsswitch_netgroup,
        enable_mkhomedir         => $_do_enable_mkhomedir,
        home_automounts          => $home_automounts,
        auth_source              => $auth_source,
        directory_source         => $directory_source,
        needs_nscd               => $needs_nscd,
        ad_server                => $ad_server,
        realm                    => $realm,
        join_domain              => $join_domain,
        renew_domain_credentials => $renew_domain_credentials,
        sshd_gssapi_auth         => $sshd_gssapi_auth,
        debug_sssd               => $debug_sssd
      }
    }
  }
}
