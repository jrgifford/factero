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
  flow width: 0.1 do
  end
  flow width: 0.8 do
    stack height: 50 do
      stack height: 10 do
      end
      stack height: 30 do
        tagline "Factero: System stats since 2012"
      end
      stack height: 10 do
      end
    end
  end
  flow width: 0.1 do
  end

  flow width: 0.7 do
    stack height: 30 do
      para "Your hostname is: #{Facter.hostname} "
    end
    stack height: 30 do
      para "Your username is: #{Facter.id} "
    end

    stack height: 30 do
      para "Your IP Address is: #{Facter.ipaddress} "
    end

    stack height: 30 do
      para "You are running: #{Facter.lsbdistdescription} "
    end

    stack height: 30 do
      para "Your uptime is: #{Facter.uptime}"
    end

    stack height: 30 do
      para "Your external IP address is: #{$ExternalIP} "
    end
  end

  flow width: 0.2 do
    stack height: 30 do
      @b1 = button "Copy"
      @b1.click{Clipboard.copy "#{Facter.hostname}"}
    end

    stack height: 30 do
      @b2 = button "Copy"
      @b2.click{Clipboard.copy "#{Facter.id}"}
    end

    stack height: 30 do
      @b3 = button "Copy"
      @b3.click{Clipboard.copy "#{Facter.ipaddress}"}
    end

    stack height: 30 do
      @b4 = button "Copy"
      @b4.click{Clipboard.copy "#{Facter.lsbdistdescription}"}
    end

    stack height: 30 do
      @b5 = button "Copy"
      @b5.click{Clipboard.copy "#{Facter.uptime}"}
    end

    stack height: 30 do
      @b6 = button "Copy"
      @b6.click{Clipboard.copy "#{$ExternalIP}"}
    end
  end
end
