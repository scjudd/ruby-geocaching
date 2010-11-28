# encoding: utf-8

module Geocaching
  # The {MyLogs} class provides access to the logs the user
  # you’re logged in with has written.
  #
  # This class does caching.  If you want to override the cached information,
  # call the {#fetch} method manually.
  #
  # == Usage
  #
  #  mylogs = Geocaching::MyLogs.fetch
  #  puts "I've written #{mylogs.logs.size} logs."
  #
  class MyLogs
    # Creates a new instance and calls {#fetch} afterwards.
    #
    # @return [Geocaching::MyLogs]
    def self.fetch
      mylogs = new
      mylogs.fetch
      mylogs
    end

    # Fetches logs from geocaching.com.
    #
    # @return [void]
    def fetch
      raise LoginError unless HTTP.loggedin?

      resp, @data = HTTP.get("/my/logs.aspx?s=1")
      @doc = Nokogiri::HTML.parse(@data)
    end

    # Returns whether logs have successfully been fetched
    # from geocaching.com.
    #
    # @return [Boolean] Have logs been fetched?
    def fetched?
      @data and @doc
    end

    # Returns an array of logs the user you’re logged in with has
    # written.
    #
    # @return [Array<Geocaching::Log>]
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

    # Extracts information from a HTML table row node.
    #
    # @return [Hash] Extracted information
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
