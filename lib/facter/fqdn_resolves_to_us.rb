# In most circumstances, the host's FQDN is useless from a network
# configuration standpoint. Unfortunately, Kerberos is the
# exception.

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

Facter.add("fqdn_resolves_to_us") do
  fqdn = Facter.value(:fqdn)
  my_ip = Facter.value(:fqdn_ip)
  setcode do
    ip_a = `ip a`
    (ip_a.include? "inet #{my_ip}" or ip_a.include? "inet6 #{my_ip}")
  end
end
