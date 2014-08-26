require 'facter'

dhcp_eth0_leases_file = File.open('/var/lib/dhcp/dhclient.eth0.leases','r')
result = Array.new
dhcp_eth0_leases_file.each_line do | line |
  if line.include? "dhcp-server-identifier"
      result.push(line.scan /\d+\.\d+\.\d+\.\d+/)
  end
end 
dhcp_eth0_leases_file.close

#puts result.last

Facter.add('dhcpserver') do
    setcode do
       result.last
#       puts result.last
    end
end

