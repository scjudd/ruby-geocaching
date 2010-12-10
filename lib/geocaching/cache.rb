# encoding: utf-8

require "time"
require "json"

module Geocaching
  # The {LogsArray} class is a subclass of +Array+ and is used to store all
  # logs that belong to a cache.  It implements the {#fetch_all} method to
  # fetch the information of all logs inside the array.
  class LogsArray < Array
    # Calls {Geocaching::Log#fetch} for each log inside the array.
    #
    # @return [Boolean] Whether all logs could be fetched successfully
    def fetch_all
      each { |log| log.fetch }
      map { |log| log.fetched? }.all?
    end
  end

  # The {Cache} class represents a cache on geocaching.com.  Altough some
  # information are available without being logged in, most information
  # will only be accessible after a successful login.
  #
  # This class does caching.  That means that multiple calls of, for example,
  # the {#latitude} method only do one HTTP request.  To override the cached
  # information, call the {#fetch} method manually.
  #
  # == Usage
  #
  #  cache = Geocaching::Cache.fetch(:code => "GCTEST")
  #  
  #  puts cache.difficulty #=> 3.5
  #  puts cache.latitude #=> 49.741541
  #  puts cache.archived? #=> false
  #
  class Cache
    # Creates a new instance and calls the {#fetch} methods afterwards.
    # One of +:code+ or +:guid+ must be provided as attributes.
    #
    # @param [Hash] attributes A hash of attributes, see {#initialize}
    # @return [Geocaching::Cache]
    # @raise [ArgumentError] Tried to set an unknown attribute
    # @raise [ArgumentError] Neither code nor GUID given
    def self.fetch(attributes)
      cache = new(attributes)
      cache.fetch
      cache
    end

    # Returns an array of caches that are located within the given bounds.
    # If the number of results exceeds 500 caches, a
    # {Geocaching::TooManyResultsError} exception is raised.
    #
    # @param [Array<Numeric>] northeast
    #   An array containing latitude and longitude of the upper right bound
    # @param [Array<Numeric>] southwest
    #   An array containing latitude and longitude of the lower left bound
    # @return [Array<Geocaching::Cache>]
    #   Array of caches within given bounds
    # @raise [ArgumentError]
    #   Invalid arguments
    # @raise [Geocaching::TooManyResultsError]
    #   Number of results exceeds 500 caches
    def self.within_bounds(northeast, southwest)
      unless northeast.kind_of?(Array) and southwest.kind_of?(Array)
        raise ArgumentError, "Arguments must be arrays"
      end

      unless northeast.size == 2 and southwest.size == 2
        raise ArgumentError, "Arguments must have two elements"
      end

      unless northeast.map { |a| a.kind_of?(Numeric) }.all? \
         and southwest.map { |a| a.kind_of?(Numeric) }.all?
        raise ArgumentError, "Latitude and longitude must be given as numbers"
      end

      post_data = {
        "dto" => {
          "data" => {
            "c" => 1,
            "m" => "",
            "d" => [northeast[0], southwest[0], northeast[1], southwest[1]].join("|")
          },
          "ut" => ""
        }
      }

      headers = {
        "Content-Type" => "application/json; charset=UTF-8"
      }

      resp, data = HTTP.post("/map/default.aspx/MapAction",
        JSON.generate(post_data), headers)

      begin
        outer = JSON.parse(data)
        raise ParseError, "Invalid JSON response" unless outer["d"]
        results = JSON.parse(outer["d"])
      rescue JSON::JSONError
        raise ParseError, "Could not parse response JSON data"
      end

      raise ParseError, "Invalid JSON response" unless results["cs"]
      raise TooManyResultsError if results["cs"]["count"] == 501

      if results["cs"]["cc"].kind_of?(Array)
        results["cs"]["cc"].map do |result|
          Cache.new \
            :name      => result["nn"],
            :code      => result["gc"],
            :latitude  => result["lat"],
            :longitude => result["lon"],
            :type      => CacheType.for_id(result["ctid"])
        end
      else
        []
      end
    end

    # Creates a new instance.  The following attributes may be specified
    # as parameters:
    #
    # * +:code+ — The cache’s GC code
    # * +:guid+ — The cache’s Globally Unique Identifier
    #
    # @param [Hash] attributes A hash of attributes
    # @raise [ArgumentError] Trying to set an unknown attribute
    def initialize(attributes = {})
      @data, @doc, @code, @guid = nil, nil, nil, nil

      attributes.each do |key, value|
        if [:code, :guid, :name, :type, :latitude, :longitude].include?(key)
          if key == :type and not value.kind_of?(CacheType)
            raise TypeError, "Attribute `type' must be an instance of Geocaching::CacheType"
          end

          instance_variable_set("@#{key}", value)
        else
          raise ArgumentError, "Trying to set unknown attribute `#{key}'"
        end
      end
    end

    # Fetches cache information from geocaching.com.
    #
    # @return [void]
    # @raise [ArgumentError] Neither code nor GUID are given
    def fetch
      raise ArgumentError, "Neither code nor GUID given" unless @code or @guid

      base_path = "/seek/cache_details.aspx?log=y&"
      resp, @data = HTTP.get(base_path + (@code ? "wp=#{@code}" : "guid=#{@guid}"))
      @doc = Nokogiri::HTML.parse(@data)
    end

    # Returns whether information have successfully been fetched
    # from geocaching.com.
    #
    # @return [Boolean] Have cache information been fetched?
    def fetched?
      @data and @doc
    end

    # Returns the cache’s code.
    #
    # @return [String] Code
    def code
      @code ||= begin
        raise NotFetchedError unless fetched?
        elements = @doc.search("#ctl00_uxWaypointName.GCCode")

        if elements.size == 1 and elements.first.content =~ /(GC[A-Z0-9]+)/
          HTTP.unescape($1)
        else
          raise ParseError, "Could not extract code from website"
        end
      end
    end

    # Returns the cache’s Globally Unique Identifier (GUID).
    #
    # @return [String] GUID
    def guid
      @guid ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_lnkPrintFriendly")
        guid = nil

        if elements.size == 1 and href = elements.first["href"]
          guid = $1 if href =~ /guid=([0-9a-f-]{36})/
        end

        guid || begin
          raise ParseError, "Could not extract GUID from website"
        end
      end
    end

    # Returns the cache’s ID (which is not the UUID).
    #
    # @return [Fixnum] ID
    def id
      @id ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("div.CacheDetailNavigationWidget li a[href^='/seek/log.aspx']")

        if elements.size > 0 and elements.first["href"] =~ /ID=(\d+)/
          id = $1.to_i
        end

        id || begin
          raise ParseError, "Could not extract ID from website"
        end
      end
    end

    # Returns the cache’s type ID.
    #
    # @return [Fixnum] Type ID
    def type_id
      @type_id ||= begin
        raise NotFetchedError unless fetched?

        if @data =~ /<a.*?title="About Cache Types"><img.*?WptTypes\/(\d+)\.gif".*?<\/a>/
          $1.to_i
        else
          raise ParseError, "Could not extract cache type ID from website"
        end
      end
    end

    # Returns the cache’s type.
    #
    # @return [Geocaching::CacheType] Type
    def type
      @type ||= CacheType.for_id(type_id)
    end

    # Returns the cache’s name.
    #
    # @return [String] Name
    def name
      @name ||= begin
        raise NotFetchedError unless fetched?
        elements = @doc.search("span#ctl00_ContentBody_CacheName")

        if elements.size == 1
          HTTP.unescape(elements.first.content)
        else
          raise ParseError, "Could not extract name from website"
        end
      end
    end

    # Returns the cache’s owner.
    #
    # @return [Geocaching::User] Owner
    def owner
      @owner ||= begin
        raise NotFetchedError unless fetched?

        if @data =~ /<strong>\s*?A[(n\s*?Event)]*\s*?cache\s*?<\/strong>\s*?by\s*?<a.*?guid=([a-f0-9-]{36}).*?>(.*?)<\/a>/
          @owner_display_name = HTTP.unescape($2)
          User.new(:guid => $1)
        else
          raise ParseError, "Could not extract owner from website"
        end
      end
    end

    # Returns the displayed cache owner name.
    #
    # @return [String] Displayed owner name
    def owner_display_name
      owner unless @owner_display_name
      @owner_display_name
    end

    # Returns the cache’s difficulty rating.
    #
    # @return [Float] Difficulty rating
    def difficulty
      @difficulty ||= begin
        raise NotFetchedError unless fetched?

        if @data =~ /<strong>\s*?Difficulty:<\/strong>\s*?<img.*?alt="([\d\.]{1,3}) out of 5" \/>/
          $1.to_f
        else
          raise ParseError, "Could not extract difficulty rating from website"
        end
      end
    end

    # Returns the cache’s terrain rating.
    #
    # @return [Float] Terrain rating
    def terrain
      @terrain ||= begin
        raise NotFetchedError unless fetched?

        if @data =~ /<strong>\s+?Terrain:<\/strong>\s+?<img.*?alt="([\d\.]{1,3}) out of 5" \/>/
          $1.to_f
        else
          raise ParseError, "Could not extract terrain rating from website"
        end
      end
    end

    # Returns the date the cache has been hidden at.
    #
    # @return [Time] Hidden date
    def hidden_at
      @hidden_at ||= begin
        raise NotFetchedError unless fetched?

        if @data =~ /<strong>\s*?Hidden\s*?:\s*?<\/strong>\s*?(\d{1,2})\/(\d{1,2})\/(\d{4})/
          Time.mktime($3, $1, $2)
        else
          raise ParseError, "Could not extract hidden date from website"
        end
      end
    end

    # Returns the date the event has been held.
    #
    # @return [Time] Event date
    def event_date
      @event_date ||= begin
        raise NotFetchedError unless fetched?
        return nil unless [:event, :megaevent, :cito, :lfevent].include?(type.to_sym)

        if @data =~ /<strong>\s*?Event Date:\s*?<\/strong>\s*?\w+, (\d+) (\w+) (\d{4})/
          Time.parse([$1, $2, $3].join)
        else
          raise ParseError, "Could not extract event date from website"
        end
      end
    end

    # Returns the cache’s container size.  One of the following symbols
    # is returned:
    #
    # * +:micro+
    # * +:small+
    # * +:regular+
    # * +:large+
    # * +:other+
    # * +:not_chosen+
    # * +:virtual+
    #
    # @return [Symbol] Cache container size
    def size
      @size ||= begin
        raise NotFetchedError unless fetched?
        size = nil

        if @data =~ /<img src="\/images\/icons\/container\/(.*?)\.gif" alt="Size: .*?" \/>/
          size = $1.to_sym if %w(micro small regular large other not_chosen virtual).include?($1)
        end

        size || begin
          raise ParseError, "Could not extract cache container size from website"
        end
      end
    end

    # Returns the cache’s latitude.
    #
    # @return [Float] Latitude
    def latitude
      @latitude ||= begin
        raise NotFetchedError unless fetched?
        return nil if type == :locationless

        latitude = nil
        elements = @doc.search("a#ctl00_ContentBody_lnkConversions")

        if elements.size == 1 and href = elements.first["href"]
          latitude = $1.to_f if href =~ /lat=(-?[0-9\.]+)/
        end

        latitude || begin
          raise ParseError, "Could not extract latitude from website"
        end
      end
    end

    # Returns the cache’s longitude.
    #
    # @return [Float] Longitude
    def longitude
      @longitude ||= begin
        raise NotFetchedError unless fetched?
        return nil if type == :locationless

        longitude = nil
        elements = @doc.search("a#ctl00_ContentBody_lnkConversions")

        if elements.size == 1 and href = elements.first["href"]
          longitude = $1.to_f if href =~ /lon=(-?[0-9\.]+)/
        end

        longitude || begin
          raise ParseError, "Could not extract longitude from website"
        end
      end
    end

    # Returns the cache’s location name (State, Country).
    #
    # @return [String] Location name
    def location
      @location ||= begin
        raise NotFetchedError unless fetched?
        return nil if type == :locationless

        location = nil
        elements = @doc.search("span#ctl00_ContentBody_Location")

        if elements.size == 1
          text = @doc.search("span#ctl00_ContentBody_Location").inner_html
          location = $1.strip if text =~ /In ([^<]+)/
        end

        location || begin
          raise ParseError, "Could not extract location from website"
        end
      end
    end

    # Returns whether the cache is unpublished or not.
    #
    # @return [Boolean] Is cache unpublished?
    def unpublished?
      @is_unpublished ||= begin
        raise NotFetchedError unless fetched?
        !!(@data =~ /<h2>Cache is Unpublished<\/h2>/)
      end
    end

    # Returns whether the cache has been archived or not.
    #
    # @return [Boolean] Has cache been archived?
    def archived?
      @is_archived ||= begin
        raise NotFetchedError unless fetched?
        !!(@data =~ /<li>This cache has been archived/)
      end
    end

    # Returns whether the cache is only viewable to Premium Member only.
    #
    # @return [Boolean] Is cache PM-only?
    def pmonly?
      @is_pmonly ||= begin
        raise NotFetchedError unless fetched?

        @doc.search("#ctl00_ContentBody_basicMemberMsg").size == 1 ||
          !!(@data =~ /<p class="Warning">This is a Premium Member Only cache\.<\/p>/)
      end
    end

    # Returns whether the cache is currently in review.
    #
    # @return [Boolean] Is cache currently in review?
    def in_review?
      @in_review ||= begin
        raise NotFetchedError unless fetched?
        [!!@data.match(/<p class="Warning">Sorry, you cannot view this cache listing until it has been published/),
         !!@data.match(/<p class="Warning">This cache listing has not been reviewed yet/)].any?
      end
    end

    # Returns an array of the cache’s logs.
    #
    # @return [Geocaching::LogsArray<Geocaching::Log>] Array of logs
    def logs
      @logs ||= begin
        raise NotFetchedError unless fetched?

        logs = LogsArray.new
        tds = @doc.search("table.Table.LogsTable > tr > td")

        if tds.size == 0
          raise ParseError, "Could not extract logs from website"
        end

        tds.each do |td|
          strongs = td.search("strong")
          next unless strongs.size > 0

          imgs    = strongs.first.search("img")
          user_as = strongs.first.search("a[href^='/profile/']")
          log_as  = td.search("small > a[href^='log.aspx']")

          unless imgs.size == 1 and user_as.size == 1 and log_as.size == 1
            raise ParseError, "Could not extract logs from website"
          end

          log_title = imgs.first["title"]
          user_name = user_as.first.text.strip
          user_guid = user_as.first["href"] =~ /guid=([a-f0-9-]{36})/ ? $1 : nil
          log_guid  = log_as.first["href"] =~ /LUID=([a-f0-9-]{36})/ ? $1 : nil

          # XXX Fix log title as Groundspeak is unable to escape their
          # HTML code properly.
          log_title = "Didn't find it" if log_title == "Didn"

          unless log_title and user_name and user_guid and log_guid
            raise ParseError, "Could not extract logs from website"
          end

          user = User.new(:guid => user_guid, :name => user_name)
          log = Log.new \
            :guid  => log_guid,
            :title => log_title,
            :cache => self,
            :user  => user

          logs << log
        end

        logs
      end
    end

    # Puts the cache on the user’s watchlist.  Obviously, you need to be logged
    # in when calling this method.
    #
    # @return [void]
    def watch
      unless HTTP.loggedin?
        raise LoginError
      end

      HTTP.get("/my/watchlist.aspx?w=#{id}")
    end

    # Removes the cache from the user’s watchlist.  This method doesn’t check
    # if the cache you want to remove from the watchlist actually is on your
    # watchlist.
    #
    # @return [void]
    def unwatch
      unless HTTP.loggedin?
        raise LoginError
      end

      HTTP.post("/my/watchlist.aspx?ds=1&id=#{id}&action=rem", {
        "ctl00$ContentBody$btnYes" => "Yes"
      })
    end

    # Returns a hash representing this cache.
    #
    # @return [Hash] Hash representing this cache
    def to_hash
      hash = {
        :id         => id,
        :code       => code,
        :guid       => guid,
        :name       => name,
        :difficulty => difficulty,
        :terrain    => terrain,
        :latitude   => latitude,
        :longitude  => longitude,
        :size       => size,
        :type       => type,
        :location   => location,
        :owner      => owner,
        :owner_display_name => owner_display_name,
        :logs       => logs,
        :pmonly?    => pmonly?,
        :archived?  => archived?,
        :in_review? => in_review?,
        :unpublished? => unpublished?
      }

      if [:event, :megaevent, :lfevent, :cito].include?(type.to_sym)
        hash[:event_date] = event_date
      else
        hash[:hidden_at] = hidden_at
      end

      hash
    end
  end
end
