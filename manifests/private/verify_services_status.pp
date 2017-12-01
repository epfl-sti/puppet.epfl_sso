

# Class: epfl_sso::private::verify_services_status
#
# This class will check the satatus of services of
# early installed  packages listed .
#
# === Parameters:
#

# nfs-common,
# autofs,
# autofs-ldap
#
#

class epfl_sso::verify_services_status {
    service { 'nfs-common':
        ensure      => running,
        enable      => true,
        hasrestart  => true,
        hasstatus   => true,
            }
    service { 'autofs':
        ensure      => running,
        enable      => true,
        hasrestart  => true,
        hasstatus   => true,
            }
    service { 'autofs':
            ensure      => running,
            enable      => true,
            hasrestart  => true,
            hasstatus   => true,
            }
}
