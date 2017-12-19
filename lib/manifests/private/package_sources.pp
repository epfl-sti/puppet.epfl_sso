#
#
#
#  



class epfl_sso::private::package_sources {
  if ($::osfamily == "RedHat") {
    if ($::operatingsystem == "RedHat") {
      exec { "subscription-manager repos --enable=rhel-${::osmajorrelease}-server-optional-rpms":
        path => $::path,
        unless => "rpm -q bsh || yum search bsh"
        } -> Package["epel-release"]
    }
    package { "epel-release":
      ensure => "present"
    }
  }
}
