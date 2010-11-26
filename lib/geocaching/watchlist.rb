# encoding: utf-8

module Geocaching
  # The {Watchlist} class gives you access to the user’s watchlist.
  class Watchlist
    # Creates a new instance of this class and calls the {#caches} method.
    def self.caches
      new.caches
    end

    # Returns an array of caches the user has on its watchlist.
    #
    # Note: This method caches the information, so multiple calls only do
    # one HTTP request.  To override the cached information, run the {#fetch}
    # method manually.
    #
    # @return [Array<Geocaching::Cache>]
    def caches
      @caches ||= begin
        caches = []
        fetch unless fetched?

        @doc.search("table.Table > tbody > tr").each do |row|
          if info = extract_info_from_row(row) and info.size == 3
            cache = Cache.new \
              :guid => info[:cache_guid],
              :name => info[:cache_name],
              :type => info[:cache_type]
            caches << cache
          end
        end

        caches
      end
    end

    # Fetches information from geocaching.com.  Usually, you only call this
    # method manually if you want to override the cached information.
    #
    # @return [void]
    def fetch
      unless HTTP.loggedin?
        raise LoginError, "You need to be logged in to access your watchlist"
      end

      resp, @data = HTTP.get(path)
      @doc = Nokogiri::HTML.parse(@data)
    end

    # Returns whether information have already been fetched from geocaching.com.
    #
    # @return [Boolean]
    def fetched?
      @data and @doc
    end

  private

    def path
      "/my/watchlist.aspx"
    end

    def extract_info_from_row(row)
      info = {}

      # Cache GUID
      elements = row.search("td:nth-child(3) a")
      if elements.size == 1
        url = elements.first["href"]
        if url and url =~ /guid=([a-f0-9-]{36})/
          info[:cache_guid] = $1
        end
      end

      # Cache type
      elements = row.search("td:nth-child(2) > img")
      if elements.size == 1
        if title = elements.first["alt"]
          if type = CacheType.for_title(title)
            info[:cache_type] = type
          end
        end
      end

      # Cache name
      elements = row.search("td:nth-child(3) a")
      if elements.size == 1
        name = elements.first.text
        info[:cache_name] = name.strip if name
      end

      info
    end
  end
end
