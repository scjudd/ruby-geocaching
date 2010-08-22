Ruby API for geocaching.com
===========================

This Ruby library provides an API for geocaching.com.  As Groundspeak
doesn’t offer an official API yet, this library parses the website’s
HTML code.

Documentation
-------------

Documentation is available at
[rdoc.info](http://rdoc.info/projects/nano/ruby-geocaching).

Example
-------

    require "geocaching"
    
    Geocaching::HTTP.login("username", "password")
    
    cache = Geocaching::Cache.fetch(:code => "GCF00")
    log = Geocaching::Log.fetch(:guid => "...")
    
    puts cache.name #=> "Bridge Over Troubled Waters"
    puts cache.difficulty #=> 2.5
    puts cache.logs.size #=> 194
    
    puts log.username #=> "Chris"
    puts log.message #=> "TFTC ..."
    puts log.cache #=> #<Geocaching::Cache:...>
    
    Geocaching::HTTP.logout

Altough some cache information are available without being logged in,
most information will only be accessible after a successful login.

Tests
-----

Tests are written using RSpec.

    $ export GC_USERNAME="username"
    $ export GC_PASSWORD="password"
    $ rake test
