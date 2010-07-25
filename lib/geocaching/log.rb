module Geocaching
  # This class represents a log on geocaching.com.
  class Log
    # Creates a new instance and calls the {#fetch} method afterwards.
    # +:guid+ must be specified as an attribute.
    #
    # @param [Hash] attributes Hash of attributes
    # @return [Geocaching::Log]
    # @raise [ArgumentError] Unknown attribute provided
    # @raise [TypeError] Invalid attribute provided
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    def self.fetch(attributes)
      log = new(attributes)
      log.fetch
      log
    end

    # Creates a new instance.  The following attributes may be specified
    # as parameters:
    #
    # * +:guid+ — The log’s Globally Unique Identifier
    # * +:cache+ — A {Geocaching::Cache} that belongs to this log
    #
    # @raise [ArgumentError] Trying to set an unknown attribute
    # @raise [TypeError] +:code+ is not an instance of {Geocaching::Cache}
    def initialize(attributes = {})
      @data, @doc, @guid, @cache = nil, nil, nil, nil

      attributes.each do |key, value|
        if [:guid, :title, :cache].include?(key)
          if key == :cache and not value.kind_of?(Geocaching::Cache)
            raise TypeError, "Attribute `cache' must be an instance of Geocaching::Cache"
          end

          instance_variable_set("@#{key}", value)
        else
          raise ArgumentError, "Trying to set unknown attribute `#{key}'"
        end
      end
    end

    # Fetches log information from geocaching.com.
    #
    # @return [void]
    # @raise [ArgumentError] GUID is not given
    # @raise [Geocaching::LoginError] Not logged in
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    def fetch
      raise ArgumentError, "No GUID given" unless @guid
      raise LoginError, "Need to be logged in to fetch log information" unless HTTP.loggedin?

      resp, @data = HTTP.get(path)
      @doc = Hpricot(@data)
    end

    # Whether information have successfully been fetched
    # from geocaching.com.
    #
    # @return [Boolean] Have information beed fetched?
    def fetched?
      @data and @doc
    end

    # The cache that belongs to this log.
    #
    # @return [Geocaching::Cache] Cache
    def cache
      @cache ||= begin
        if guid = cache_guid
          Cache.new(:guid => guid)
        end
      end
    end

    def title
      @title
    end

    # The name of the user that has posted this log.
    #
    # @return [String] Username
    # @raise [Geocaching::NotFetchedError] Need to call {#fetch} before
    # @raise [Geocaching::ExtractError] Could not extract username from website
    def username
      @username ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_LogBookPanel1_lbLogText > a")

        if elements.size > 0
          HTTP.unescape(elements.first.inner_html)
        else
          raise ExtractError, "Could not extract username from website"
        end
      end
    end

    # The log’s raw message with all format codes.
    #
    # @return [String] Log message
    # @raise [Geocaching::NotFetchedError] Need to call {#fetch} before
    # @raise [Geocaching::ExtractError] Could not extract message from website
    def message
      @message ||= begin
        raise NotFetchedError unless fetched?

        if meta[:description]
          meta[:description].gsub(/\r\n/, "\n")
        else
          raise ExtractError, "Could not extract message from website"
        end
      end
    end

    # The short coord.info URL for this log.
    #
    # @return [String] coord.info URL
    # @raise [Geocaching::NotFetchedError] Need to call {#fetch} before
    # @raise [Geocaching::ExtractError] Could not extract short URL from website
    def short_url
      @short_url ||= begin
        raise NotFetchedError unless fetched?

        meta[:url] || begin
          raise ExtractError, "Could not extract short URL from website"
        end
      end
    end

  private

    def cache_guid
      if @cache.kind_of?(Geocaching::Cache) and @cache.guid
        @cache.guid
      else
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_LogBookPanel1_lbLogText > a")

        if elements.size == 2 and elements[1]["href"]
          elements[1]["href"] =~ /guid=([a-f0-9-]{36})/
          $1
        else
          raise ExtractError, "Could not extract cache GUID from website"
        end
      end
    end

    def meta
      @meta ||= begin
        elements = @doc.search("meta").select { |e| e.attributes["name"] =~ /^og:/ }.flatten
        info = {}

        elements.each do |element|
          info[element["name"].gsub(/^og:/, "").to_sym] = element["content"]
        end

        info
      end
    end

    def path
      "/seek/log.aspx?LUID=#{@guid}"
    end
  end
end
