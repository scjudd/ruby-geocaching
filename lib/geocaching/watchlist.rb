module Geocaching
  class Watchlist
    def self.caches
      new.caches
    end

    def caches
      caches = []
      fetch

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

  private

    def path
      "/my/watchlist.aspx"
    end

    def fetch
      raise LoginError, "You need to be logged in to view your watchlist" unless HTTP.loggedin?

      resp, @data = HTTP.get(path)
      @doc = Nokogiri::HTML.parse(@data)
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
