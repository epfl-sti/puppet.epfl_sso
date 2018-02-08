# coding: utf-8
# Class: epfl_sso::krb5::ssh
#
# Allow access to this computer through ssh with Kerberos-based authentication
#
# To test, set up a section in your .ssh/config like so: (replace <mygaspar>
# with your GASPAR login name)
#
# Host ielgesrv1
#      User <mygaspar>
#      GSSAPIAuthentication yes
#      GSSAPIDelegateCredentials yes
#
# === Parameters:
#
# $enable_gssapi:: true to turn on access, false to turn it off
#
# === Actions:
#
# * Set GSSAPIAuthentication to 'yes' in /etc/ssh/ssh_config
#
class epfl_sso::private::sshd(
  $enable_gssapi = true
) {
  case $::osfamily {
    "RedHat": {
      $_sshd_service = "sshd"
      $_sshd_config_file = "/etc/ssh/sshd_config"
    }
    "Debian": {
      $_sshd_service = "ssh"
      $_sshd_config_file = "/etc/ssh/sshd_config"
    }
    default: {
      fail("Not too sure what the sshd service eats in winter on ${::osfamily}-like operating systems")
    }
  }

  define sshd_config_line() {
    file_line { "${title} in ${::epfl_sso::private::sshd::_sshd_config_file}":
      path => $::epfl_sso::private::sshd::_sshd_config_file,
      line => $title,
      ensure => $::epfl_sso::private::sshd::enable_gssapi ? {
        true => "present",
        default => "absent"
      }
    } ~> Service[$epfl_sso::private::sshd::_sshd_service]
  }
  sshd_config_line { ['KerberosAuthentication yes',
                      'GSSAPIAuthentication yes',
                      'GSSAPICleanupCredentials yes'] : }

  service { "$_sshd_service":
    ensure => "running"
  }
}
