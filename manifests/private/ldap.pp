# Manage client-side LDAP configuration and certificates
#
#Amended by Dominique on : 2017.12.11
#-------------------------------------
#
#

class epfl_sso::private::ldap {
  anchor { "epfl_sso::private::ldap::tools_installed": }
  if ($::kernel == 'Linux') {
    # Mac OS X has curl by default
    ensure_packages("curl")
    Package["curl"]
    -> Anchor["epfl_sso::private::ldap::tools_installed"]
  }
  case $::osfamily {
    'Debian': {
      $trusted_cert_dir = "/usr/share/ca-certificates/epfl"
      $cert_extension = "crt"
      ensure_packages("ca-certificates")
      Package["ca-certificates"]
      -> Anchor["epfl_sso::private::ldap::tools_installed"]
    }
    'RedHat': {
      $trusted_cert_dir = "/etc/openldap/certs"
      $cert_extension = "pem"
      ensure_packages("nss-tools")
      Package["nss-tools"]
      -> Anchor["epfl_sso::private::ldap::tools_installed"]
    }
    'Darwin': {
      $trusted_cert_dir = "/etc/openldap/certs"
      $cert_extension = "pem"
    }
    default: {
      fail("Not sure how to wrangle LDAP configuration on ${::osfamily}")
    }
  }  # case $::osfamily

  # Trust / untrust a certificate for the purpose of LDAP client traffic
  # On some platforms (Debian, Mac OS X), the trust is actually extended / revoked
  # for *all* purposes, i.e. the certificates go into the global keychain / store
  define trusted_ca_cert(
    $url,
    $ensure = "present"
  ) {
    $trusted_cert_dir = $::epfl_sso::private::ldap::trusted_cert_dir
    $cert_pem_basename = "${title}.${::epfl_sso::private::ldap::cert_extension}"
    $cert_pem_path = "${trusted_cert_dir}/${cert_pem_basename}"

    $url_is_pem = inline_template('<%= (@url.ends_with? "pem") ? "true" : "false" >')
    if ('true' == $url_is_pem) {
      $cert_retrieve_command = inline_template('curl -o <%= @cert_pem_path %> <%= @url %>')
    } else {
      $tmpcer = inline_template('<%= @trusted_cert_dir %>/<%= File.basename @url %>')
      $cert_retrieve_command = inline_template('true ; set -e -x; curl -o <%= @tmpcer %> <%= @url %> ; openssl x509 -inform der -outform pem -in <%= @tmpcer %> -out <%= @cert_pem_path %>; rm <%= @tmpcer %>')
    }

    anchor { "epfl_sso::private::ldap::cert_downloaded_or_removed::${url}": }
    if ($ensure == "present") {
      ensure_resource("file", $trusted_cert_dir, { ensure => 'directory' })
      File[$trusted_cert_dir]
      ->
      exec { $cert_retrieve_command:
        path => $::path,
        creates => $cert_pem_path,
        require => Anchor["epfl_sso::private::ldap::tools_installed"]
      }
      ~> Anchor["epfl_sso::private::ldap::cert_downloaded_or_removed::${url}"]
    } else {
      file { $cert_pem_path:
        ensure => "absent"
      }
      ~> Anchor["epfl_sso::private::ldap::cert_downloaded_or_removed::${url}"]
    }

    # Platform-specific janitorial tasks
    case $::osfamily {
      'Debian': {
        $cert_conf_file = "/etc/ca-certificates.conf"
        $file_line = "${title} in ${cert_conf_file}"
        file_line { $file_line:
          path => $cert_conf_file,
          line => "epfl/${cert_pem_basename}",
          ensure => $ensure
        } ~>
        exec { "update-ca-certificates":
          path => $::path,
          refreshonly => true,
          require => [
                      File_line[$file_line],
                      Anchor["epfl_sso::private::ldap::tools_installed"],
                      Anchor["epfl_sso::private::ldap::cert_downloaded_or_removed::${url}"]
                      ]
        }
      }
      'RedHat': {
        $_certutil_base_cmd = "certutil -d ${::epfl_sso::private::ldap::trusted_cert_dir}"
        if ($ensure == "present") {
          exec { "${_certutil_base_cmd} -n ${title} -t TCu,Cu,Tuw -A -a -i ${cert_pem_path}":
            path => $::path,
            unless => "${_certutil_base_cmd} -L | grep ${title}",
            require => [
                        Anchor["epfl_sso::private::ldap::tools_installed"],
                        Anchor["epfl_sso::private::ldap::cert_downloaded_or_removed::${url}"]
                      ]
          }
        } else {  # Disable
          file { $cert_pem_path:
            ensure => "absent"
          }
          exec { "${_certutil_base_cmd} -D -n ${title}":
            path => $::path,
            onlyif => "${_certutil_base_cmd} -L | grep ${title}",

            require => [
                        Anchor["epfl_sso::private::ldap::tools_installed"],
                        Anchor["epfl_sso::private::ldap::cert_downloaded_or_removed::${url}"]
                      ]
          }
        }
      }
      'Darwin': {
        # https://apple.stackexchange.com/a/80625/41484
        if ($ensure == "present") {
          $_add_command = "security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ${cert_pem_path}"
          Anchor["epfl_sso::private::ldap::cert_downloaded_or_removed::${url}"]
          -> exec { $_add_command:
            path => $::path,
            # Run _add_command a first time in the unless clause. If
            # it suceeds that's good, and we stop here; if not, the
            # unless clause will be false and therefore the "regular"
            # exec construct will run _add_command a second time, and
            # errors will be shown to the operator.
            unless => $_add_command
          }
        }
        if ($ensure == "absent") {
          $_remove_command = "security remove-trusted-cert -d ${cert_pem_path}"
          exec { $_remove_command:
            path => $::path,
            onlyif => "test -f ${cert_pem_path}",
            # Run _remove_command twice (so we don't have to reason
            # about any previous state). The second run is expected to
            # fail with "cert could not be found"; if not, the unless
            # clause will be false and therefore the "regular" exec
            # construct will cause _remove_command to run a third
            # time, and errors will be shown to the operator.
            unless => "${_remove_command} >/dev/null 2>&1; ${_remove_command} 2>&1|grep 'could not be found'"
          }
          -> File[$cert_pem_path]  # That is, don't delete it until security remove-trusted-cert has run
        }
      }
    }  # case $::osfamily
  }
}
