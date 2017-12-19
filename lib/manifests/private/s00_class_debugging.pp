
# Class: epfl_sso::private::s00_class debugging
#
# Adding debug messages to your manifests
# I want to add some debug messages to puppet so I can see what's happening in my manifests.
#
# === Parameters:
#
#Depending on OS, its  version and distribution, NOT yet treated
#
# $ad_server,
# $realm,
# $join_domain,
# $epflca_cert_url = 'http://certauth.epfl.ch/epflca.cer',
# $renew_domain_credential
#
#
#   class epfl_sso::private::params {
class class epfl_sso::private::debugging {


    notice("My AD_Server ${::ad_server} ")

    notify {"Running with \realm ${::realm} ID defined":}

    notify {"Running with \$join_domain ${::join_domain} ":

    withpath => true,
  }

}

class debug_with_path {

  notify { 'FqdnTest':
    withpath => true,
    name     => "my fqdn is ${::fqdn}",
  }

}
