# encoding: utf-8

module Geocaching
  # The {Log} class represents a log on geocaching.com.
  #
  # This class does caching.  That means that multiple calls of, for example,
  # the {#date} method only do one HTTP request.  If you want to override the
  # cached information, call the {#fetch} method manually.
  class Log
    # Creates a new instance and calls the {#fetch} method afterwards.
    # +:guid+ must be specified as an attribute.
    #
    # @param [Hash] attributes Hash of attributes
    # @return [Geocaching::Log]
    # @raise [ArgumentError] Unknown attribute provided
    # @raise [TypeError] Invalid attribute provided
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
        if [:guid, :title, :date, :cache].include?(key)
          if key == :cache and not value.kind_of?(Geocaching::Cache)
            raise TypeError, "Attribute `cache' must be an instance of Geocaching::Cache"
          end

          if key == :date and not value.kind_of?(Time)
            raise TypeError, "Attribute `type' must be an instance of Time"
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
    def fetch
      raise ArgumentError, "No GUID given" unless @guid
      raise LoginError unless HTTP.loggedin?

      resp, @data = HTTP.get(path)
      @doc = Nokogiri::HTML.parse(@data)
    end

    # Returns whether log information have successfully been fetched
    # from geocaching.com.
    #
    # @return [Boolean] Have log information beed fetched?
    def fetched?
      @data and @doc
    end

    # Returns the cache that belongs to this log.
    #
    # @return [Geocaching::Cache] Cache
    def cache
      @cache ||= begin
        if guid = cache_guid
          Cache.new(:guid => guid)
        end
      end
    end

    # Returns the log’s type.
    #
    # @return [Geocaching::LogType] Log type
    def type
      @type ||= LogType.for_title(title)
    end

    # Returns the name of the user that posted the log.
    #
    # @return [String] Username
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

    # Returns the date the log was written at.
    #
    # @return [Time] Log date
    def date
      @date ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_LogBookPanel1_LogDate")

        if elements.size == 1
          Time.parse(elements.first.content)
        else
          raise ExtractError, "Could not extract date from website"
        end
      end
    end

    # Returns the log’s raw message with all format codes.
    #
    # @return [String] Raw log message
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

    # Returns thehe short coord.info URL for the log.
    #
    # @return [String] coord.info URL
    def short_url
      @short_url ||= begin
        raise NotFetchedError unless fetched?

        meta[:url] || begin
          raise ExtractError, "Could not extract short URL from website"
        end
      end
    end

  private

    # Returns the log’s title which is used internally to get the log type.
    #
    # @return [String] Log title
    def title
      @title ||= begin
        raise NotFetchedError unless fetched?

        imgs = @doc.search("#ctl00_ContentBody_LogBookPanel1_LogImage")

        unless imgs.size == 1 and imgs.first["alt"]
          raise ExtractError, "Could not extract title from website"
        end

        imgs.first["alt"]
      end
    end

    # Returns the UUID of the cache that belongs to this log.
    #
    # @return [String] Cache UUID
    def cache_guid
      if @cache.kind_of?(Geocaching::Cache) and @cache.guid
        @cache.guid
      else
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_LogBookPanel1_lbLogText > a")

        if elements.size == 3 and elements[1]["href"]
          elements[1]["href"] =~ /guid=([a-f0-9-]{36})/
          $1
        else
          raise ExtractError, "Could not extract cache GUID from website"
        end
      end
    end

    # Returns an array of information that are provided on the website
    # in <meta> tags.
    #
    # @return [Hash] Log information
    def meta
      @meta ||= begin
        elements = @doc.search("meta").select { |e| e["name"] =~ /^og:/ }.flatten
        info = {}

        elements.each do |element|
          info[element["name"].gsub(/^og:/, "").to_sym] = element["content"]
        end

        info
      end
    end

    # Returns the HTTP request path.
    #
    # @return [String] HTTP request path
    def path
      "/seek/log.aspx?LUID=#{@guid}"
    end
  end
end
