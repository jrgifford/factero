require 'green_shoes'
require 'facter'
require 'clipboard'
require 'net/http'



# lets try the Yahoo! caching system from http://developer.yahoo.com/ruby/ruby-cache.html

class MemFetcher
   def initialize
      # we initialize an empty hash
      @cache = {}
   end
   def fetch(url, max_age=0)
      # if the API URL exists as a key in cache, we just return it
      # we also make sure the data is fresh
      if @cache.has_key? url
         return @cache[url][1] if Time.now-@cache[url][0]<max_age
      end
      # if the URL does not exist in cache or the data is not fresh,
      #  we fetch again and store in cache
      @cache[url] = [Time.now, Net::HTTP.get_response(URI.parse(url)).body]
   end
end

$fetcher = MemFetcher.new

class WhatIsMy
  def self.external_ip
    $fetcher.fetch('http://icanhazip.com/', 60)
  end
end

$CopyExternalIP = WhatIsMy::external_ip.last.to_s

Shoes.app( :title => "System Stats", :width => 400, :height => 250 ) do
  background lightsteelblue
  para "Your hostname is: " + Facter.hostname + " ", link(strong("Copy")){Clipboard.copy "#{Facter.hostname}"}
  para "Your username is: " + Facter.id + " ", link(strong("Copy")){Clipboard.copy "#{Facter.id}"}
  para "Your IP Address is: " + Facter.ipaddress + " ", link(strong("Copy")){Clipboard.copy "#{Facter.ipaddress}"}
  para "You are running: " + Facter.lsbdistdescription + " ", link(strong("Copy")){Clipboard.copy "#{Facter.lsbdistdescription}"}
  para "Your uptime is: " + Facter.uptime + " ", link(strong("Copy")){Clipboard.copy "#{Facter.uptime}"}
  para "Your external IP address is: " + $CopyExternalIP + " ", link(strong("Copy")){Clipboard.copy "#{$CopyExternalIP}"}
end
