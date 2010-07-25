Ruby library for accessing geocaching.com information
=====================================================

This Ruby library provides access to cache and log information
on geocaching.com.  It works by parsing the website’s content as
Groundspeak does not offer an API yet.


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
