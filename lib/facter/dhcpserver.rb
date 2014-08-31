require 'facter'
require 'facter/util/ip'

Facter::Util::IP.get_interfaces.each do |interface|
  next if interface == 'lo'
  next if !File.exist?("/var/lib/dhcp/dhclient.#{interface}.leases")
  Facter.add('dhcpserver' + '_' + Facter::Util::IP.alphafy(interface)) do
    setcode do
      dhcp_leases_file = File.open("/var/lib/dhcp/dhclient.#{interface}.leases",'r')
      result = Array.new
      dhcp_leases_file.each_line do | line |
        result.push(line.scan /\d+\.\d+\.\d+\.\d+/) if line.include? "dhcp-server-identifier"
      end
      dhcp_leases_file.close
      result.last
    end
  end
end
