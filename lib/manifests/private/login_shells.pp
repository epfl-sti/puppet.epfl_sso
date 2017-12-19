# Ensure all EPFL-supported login shells are available.
#
# When a user tries to ssh into a machine that doesn't have their login shell
# available, it can be challenging to figure out the problem.
#
# EPFL's default shell can be changed in self-service here:
#       https://cadiwww.epfl.ch/cgi-bin/accountprefs/
#
# As of Feb, 2017 the options are
#
# /bin/sh
# /bin/bash
# /bin/tcsh
# /bin/zsh
# /bin/csh
# /bin/bash2
# /bin/ash
# /bin/bsh
# /sbin/nologin
#
#
            
class epfl_sso::private::login_shells {
  # This seems to be the lowest common denominator across distributions:
  ensure_packages(['tcsh', 'zsh', 'bsh'])
  case $::osfamily {
    "Debian": {
      ensure_packages(['ash', 'csh'])  # In addition to above
    }
    "RedHat": {
      package { "ash":
        provider => "rpm",
        source => "http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el5/en/x86_64/rpmforge/RPMS/ash-0.3.8-20.el5.rf.x86_64.rpm"
      }
      file { "/bin/csh":
        ensure => "link",
        target => "tcsh"
      }
    }
  }
}
