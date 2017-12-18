
# Class: class epfl_sso::s40_endurance_testing
#
# The user will renew his ticket once duraing the test.
<<<<<<< HEAD
#The nfs ssession must be up duraing 48 hours
=======
# The nfs ssession must be up duraing 48 hours
>>>>>>> 631712c972524e13fa8d68b45b3213713b6f2804
#
#L'utilisateur devra renouveler son ticket une fois pendant le test d'endurance
# La session NFS doit alors survivre pendant les 48 heures
# === Parameters:
#
<<<<<<< HEAD

class epfl_sso::s40_endurance_testing {
    package { 'nfs-common':
          ensure => present,
        }
    package { 'autofs':
          ensure => present,
        }
    package { 'autofs-ldap':
          ensure => present,
        }
}
=======
>>>>>>> 631712c972524e13fa8d68b45b3213713b6f2804
