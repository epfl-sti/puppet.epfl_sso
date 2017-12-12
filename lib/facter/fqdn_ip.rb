# What IP does our FQDN resolve to?
#
# Except in some cases (e.g. our FQDN is in .intranet.epfl.ch and we
# are not joined to the domain yet), it is fatal to Kerberos for the
# result not to be == ${::ipaddress}.

require 'logger'
require 'resolv'

$logger = Logger.new(STDERR)

Facter.add("fqdn_ip") do
  fqdn = Facter.value(:fqdn)
  setcode do
    begin
      Resolv.getaddress(fqdn)
    rescue Resolv::ResolvError
      ""
    end
  end
end
