Ruby API for geocaching.com
===========================

This Ruby library provides an API for geocaching.com.


Usage
-----

    require "geocaching"
    
    # Logging in is not always necessary, but some information are only
    # accessible when logged in.
    Geocaching::HTTP.login("username", "password")
    
    # Fetch the information for a cache by the cache’s GC code.  You can also
    # provide the cache’s GUID instead of the GC code.
    cache = Geocaching::Cache.fetch(:code => "...")
    
    # Print some cache information.
    puts "      Name: #{cache.name}"
    puts "Difficulty: #{cache.difficulty}"
    puts "     Owner: #{cache.owner.username}"
    
    # Print the number of logs.
    puts "      Logs: #{cache.logs.size}"
    
    # Print the number of users that didn’t find the cache.
    dnfs = cache.logs.select { |log| log.type == :dnf }.size
    puts "      DNFs: #{dnfs}"
    
    # Fetch the information for a log by its GUID.
    log = Geocaching::Log.fetch(:guid => "...")
    
    # Print some log information.
    puts "Username: #{log.user.name}"
    puts "   Words: #{log.message.split.size}"
    puts "   Cache: #{log.cache.name}"
    
    Geocaching::HTTP.logout

The whole library may raise the following exceptions:

* `Geocaching::TimeoutError` when a timeout is hit.
* `Geocaching::LoginError` when calling a method that requires being
  logged in and you’re not.
* `Geocaching::NotFetchedError` when accessing a method that requires the
  `fetch` method to be called first.
* `Geocaching::ExtractError` when information could not be extracted
  out of the website’s HTML code.  This mostly happens after Groundspeak
  changed their website.
* `Geocaching::HTTPError` when a HTTP request failed.

All exceptions are subclasses of `Geocaching::Error`.


Tests
-----

Tests are written using [RSpec](http://relishapp.com/rspec).

    $ export GC_USERNAME="username"
    $ export GC_PASSWORD="password"
    $ rake test

Additional environment variables you may specify are:

* `GC_TIMEOUT` — HTTP timeout in seconds
* `GC_CACHE_TYPES` — A space-separated list of cache types you want to test.
* `GC_LOG_TYPES` — A space-separated list of log types you want to test.
