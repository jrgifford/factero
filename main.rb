require 'green_shoes'
require 'facter'

Shoes.app( :title => "System Stats", :width => 350, :height => 250 ) do
  background linen
  para "Your hostname is: " + Facter.hostname
  para "Your username is: " + Facter.id
  para "Your IP Address is: " + Facter.ipaddress
  para "You are running: " + Facter.lsbdistdescription
  para "Your uptime is: " + Facter.uptime
  para "Your external IP address is: " + `curl http://icanhazip.com/`
end
