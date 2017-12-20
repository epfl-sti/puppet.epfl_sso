# Kerberos and GSSAPI configuration (client and server)
#
# Ceated  by Dominique on : 2017.12.11
# Amended by Dominique on : 2017.12.11
#-------------------------------------
# === Parameters:
#
# $ensure:: Set to a true value to fail if the configuration cannot
#           support server-side GSSAPI (e.g. DHCP client or
#           incorrectly configured IP entry in /etc/hosts). Note that
#           enrolling in Active Directory is also a requirement, but
#           is *not* provided by this class (see epfl_sso::private::ad
#           instead)

class epfl_sso::private::gssapi(
  $ensure = $epfl_sso::private::params::ensure_gssapi_server
) inherits epfl_sso::private::params {
  # In most circumstances, the host's FQDN is useless from a network
  # configuration standpoint. Unfortunately, Kerberos is the
  # exception. Whenever a Kerberized session needs to be established,
  # the client or server will request a session key from the KDC and
  # needs to know the exact identity of its communicating party in
  # order to do so successfully.
  if (($ensure == "fixed-ip") and ($::fqdn_ip != $::ipaddress)) {
    fail("Resolved IP address for ${::fqdn} is ${fqdn_ip}; expected ${ipaddress}")
  }

  # There is no opting out of these checks.
  if ($::epfl_krb5_resolved == "false") {
    fail("Unable to resolve KDC in DNS - You must use the EPFL DNS servers.")
  }

  file { $::epfl_sso::private::params::krb5_conf_file:
    content => template("epfl_sso/krb5.conf.erb")
  }

  define ssh_auth_line() {
    file_line { "GSSAPIAuthentication 'yes' in ${title}":
      path => $title,
      line => "    GSSAPIAuthentication yes",
      match => "GSSAPIAuthentication",
      ensure => "present",
      multiple => true
    }
  }

  $ssh_config = "/etc/ssh/ssh_config"
  $sshd_config = "/etc/ssh/sshd_config"
  epfl_sso::private::gssapi::ssh_auth_line { $ssh_config: }

  if ($ensure) {
    epfl_sso::private::gssapi::ssh_auth_line { $sshd_config: }  ~>
    service { "sshd":
      ensure => "running"
    }
  }

  include epfl_sso::private::pam
  epfl_sso::private::pam::module { "krb5": }
}
