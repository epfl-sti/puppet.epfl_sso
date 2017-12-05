
# cclass epfl_sso::s07b_pacakges_version
#
# This class will check those services versions' are latest:
#     sssd .
#     autofs
# Then cheking their stop & restart
#
# sssd et autofs , latest version
#
# === Parameters:
#
#
#

class epfl_sso::s07b_pacakges_version {
    package { 'sssd'  :   ensure => latest,}
    package { 'autofs':   ensure => latest,}
}
