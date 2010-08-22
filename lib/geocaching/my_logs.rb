module Geocaching
  # This class provides access to the logs the user currently logged in
  # has written.
  #
  #  mylogs = Geocaching::MyLogs.fetch
  #  puts "I've written #{mylogs.size} logs."
  class MyLogs
    # Create a new instance and call {fetch} afterwards.
    #
    # @return [Geocaching::MyLogs]
    # @raise [Geocaching::LoginError] Need to be logged in to fetch own logs
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    def self.fetch
      mylogs = new
      mylogs.fetch
      mylogs
    end

    # Fetch logs from geocaching.com.
    #
    # @return [void]
    # @raise [Geocaching::LoginError] Need to be logged in to fetch own logs
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    def fetch
      raise LoginError, "Need to be logged in to fetch your logs" unless HTTP.loggedin?

      resp, @data = HTTP.get(path)
      @doc = Nokogiri::HTML.parse(@data)
    end

    # Return whether logs have successfully been fetched from
    # geocaching.com.
    #
    # @return [Boolean]
    def fetched?
      @data and @doc
    end

    # Return an array of logs the user you’re logged in with has
    # written.
    #
    # @return [Array<Geocaching::Log>]
    # @raise [Geocaching::NotFetchedError] Need to call {fetch} first.
    def logs
      @logs ||= begin
        raise NotFetchedError unless fetched?

        rows = @doc.search("table.Table tr")
        logs = []

        rows.each do |row|
          if info = extract_info_from_row(row) and info.size == 6
            cache = Cache.new \
              :guid => info[:cache_guid],
              :name => info[:cache_name],
              :type => info[:cache_type]
            log = Log.new \
              :guid  => info[:log_guid],
              :title => info[:log_title],
              :date  => info[:log_date],
              :cache => cache

            logs << log
          end
        end

        logs
      end
    end

  private

    def path
      "/my/logs.aspx?s=1"
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
      elements = row.search("td:nth-child(3) a > img")
      if elements.size == 1
        if title = elements.first["title"]
          if type = CacheType.for_title(title)
            info[:cache_type] = type
          end
        end
      end

      # Cache name
      elements = row.search("td:nth-child(3)")
      if elements.size == 1
        archived = elements.first.search("span.Strike.Warning > a > span > strike > font")
        if archived.size == 1
          name = archived.first.content
          info[:cache_name] = name if name
        else
          disabled = elements.first.search("strike > a > span > strike")
          if disabled.size == 1
            name = disabled.first.content
            info[:cache_name] = name if name
          else
            enabled = elements.first.search("a > span")
            if enabled.size == 1
              name = enabled.first.content
              info[:cache_name] = name if name
            end
          end
        end
      end

      # Log GUID
      elements = row.search("td:nth-child(5) a")
      if elements.size == 1
        url = elements.first["href"]
        if url and url =~ /LUID=([a-f0-9-]{36})/
          info[:log_guid] = $1
        end
      end

      # Log title
      elements = row.search("td:first-child img")
      if elements.size == 1
        title = elements.first["alt"]
        info[:log_title] = title if title
      end

      # Log date
      elements = row.search("td:nth-child(2)")
      if elements.size == 1
        if elements.first.content =~ /(\d{2})\/(\d{2})\/(\d{4})/
          info[:log_date] = Time.mktime($3, $1, $2)
        end
      end

      info
    end
  end
end
