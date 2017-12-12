require 'logger'
require 'resolv'

$logger = Logger.new(STDERR)

Facter.add('epfl_krb5_resolved') do
  resolver = Resolv::DNS.new
  has_srv = ! resolver.getresources("_kerberos._tcp.intranet.epfl.ch",
                                    Resolv::DNS::Resource::IN::SRV).empty?
  setcode do has_srv end
end
