require 'green_shoes'
require 'facter'
require 'net/http'

class WhatIsMy
  def self.external_ip
    url = "http://icanhazip.com/"
    resp = Net::HTTP.get_response(URI.parse(url))
    resp.body
  end
end

Shoes.app( :title => "System Stats", :width => 350, :height => 250 ) do
  background linen
  para "Your hostname is: " + Facter.hostname
  para "Your username is: " + Facter.id
  para "Your IP Address is: " + Facter.ipaddress
  para "You are running: " + Facter.lsbdistdescription
  para "Your uptime is: " + Facter.uptime
  para "Your external IP address is: " + WhatIsMy::external_ip
end
