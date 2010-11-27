# encoding: utf-8

require "nokogiri"

# This is a Ruby library to access information on geocaching.com.  As
# Groundspeak does not provide a public API yet, one needs to parse the
# website content.  That’s what this library does.
#
# The whole library may raise the following exceptions:
#
# * {Geocaching::LoginError}
# * {Geocaching::NotFetchedError}
# * {Geocaching::ExtractError}
# * {Geocaching::TimeoutError}
# * {Geocaching::HTTPError}
#
# == Usage
#
# To have access to all information, you will need to provide the
# credentials for an account on geocaching.com and log in:
#
#  Geocaching::HTTP.login("username", "password")
#
# Make sure to log out when you’re done:
#
#  Geocaching::HTTP.logout
# 
# You know have access to all information that are available for the
# account you provided.
#
#  cache = Geocaching::Cache.fetch(:code => "GCTEST")
#  p cache.difficulty #=> 3.5
#  p cache.latitude #=> 49.17518
#  p cache.pmonly? #=> false
#  p cache.logs.size #=> 41
#
#  log = Geocaching::Log.new(:guid => "07208985-f7b2-456a-b0a8-bbc26f28b5a9")
#  log.fetch
#  p log.cache #=> #<Geocaching::Cache:...>
#  p log.username #=> Foobar
#
module Geocaching
  # All exceptions raised by this library are subclasses of this class.  It
  # easily allows to rescue from all exceptions by catching Geocaching::Error.
  class Error < Exception
  end

  # This exception is raised when a method that requires being
  # logged in is called when not logged in.
  class LoginError < Error
  end

  # This exception is raised when a timeout is hit.
  class TimeoutError < Error
  end

  # This exception is raised if a request exceeds 500 results.
  class TooManyResultsError < Error
    def initialize
      super "Your request exceeded 500 results"
    end
  end

  # This exception is raised when a method is called that requires
  # the #fetch method to be called first.
  class NotFetchedError < Error
    def initialize
      super "Need to call the #fetch method first"
    end
  end

  # This exception is raised when information could not be
  # extracted out of the website’s HTML code.  For example,
  # this may happen if Groundspeak changed their website.
  class ExtractError < Error
  end

  # This exception is raised when a HTTP request failed.
  class HTTPError < Error
  end

  autoload :HTTP, "geocaching/http"
  autoload :Cache, "geocaching/cache"
  autoload :CacheType, "geocaching/cache_type"
  autoload :Log, "geocaching/log"
  autoload :LogType, "geocaching/log_type"
  autoload :MyLogs, "geocaching/my_logs"
  autoload :User, "geocaching/user"
  autoload :Watchlist, "geocaching/watchlist"
  autoload :VERSION, "geocaching/version"
end
