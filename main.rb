require 'green_shoes'
require 'facter'
require 'clipboard'
require 'net/http'

class WhatIsMy
  def self.external_ip
    url = "http://icanhazip.com/"
    resp = Net::HTTP.get_response(URI.parse(url))
    resp.body
  end
end

#echo "foobar" | xclip -selection clipboard

Shoes.app( :title => "System Stats", :width => 400, :height => 250 ) do
  background lightsteelblue
  para "Your hostname is: " + Facter.hostname + " ", link(strong("Copy")){Clipboard.copy "#{Facter.hostname}"}
  para "Your username is: " + Facter.id + " ", link(strong("Copy")){Clipboard.copy "#{Facter.id}"}
  para "Your IP Address is: " + Facter.ipaddress + " ", link(strong("Copy")){Clipboard.copy "#{Facter.ipaddress}"}
  para "You are running: " + Facter.lsbdistdescription + " ", link(strong("Copy")){Clipboard.copy "#{Facter.lsbdistdescription}"}
  para "Your uptime is: " + Facter.uptime + " ", link(strong("Copy")){Clipboard.copy "#{Facter.uptime}"}
  para "Your external IP address is: " + WhatIsMy::external_ip + " ", link(strong("Copy")){Clipboard.copy "#{WhatIsMy::external_ip}"}
end
