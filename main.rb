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

$ExternalIP = WhatIsMy::external_ip.last.to_s

Shoes.app( :title => "System Stats", :width => 500, :height => 250 ) do
  background linen
    tagline "      Factero: System stats since 2012"
  flow width: 0.1 do
  end

  flow width: 0.7 do
    stack height: 24 do
      para "Your hostname is: " + Facter.hostname + " "
    end

    stack height: 24 do
      para "Your username is: " + Facter.id + " "
    end

    stack height: 24 do
      para "Your IP Address is: " + Facter.ipaddress + " "
    end

    stack height: 24 do
      para "You are running: " + Facter.lsbdistdescription + " "
    end

    stack height: 24 do
      para "Your uptime is: " + Facter.uptime + " "
    end

    stack height: 24 do
      para "Your external IP address is: " + $ExternalIP + " "
    end
  end

  flow width: 0.2 do
    para link(strong("Copy")){Clipboard.copy "#{Facter.hostname}"}
    para link(strong("Copy")){Clipboard.copy "#{Facter.id}"}
    para link(strong("Copy")){Clipboard.copy "#{Facter.ipaddress}"}
    para link(strong("Copy")){Clipboard.copy "#{Facter.lsbdistdescription}"}
    para link(strong("Copy")){Clipboard.copy "#{Facter.uptime}"}
    para link(strong("Copy")){Clipboard.copy "#{$ExternalIP}"}
  end
end
