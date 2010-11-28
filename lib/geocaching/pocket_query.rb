# encoding: utf-8

module Geocaching
  # The {PocketQuery} class represents a Pocket Query.
  #
  # == Usage
  #
  # === Downloading a Pocket Query
  #
  #  avail_pqs = Geocaching::PocketQuery.ready_for_download
  #  pq = avail_pqs.first
  #  pq.download
  #  
  #  puts "The PQ contains #{pq.results} caches."
  #
  # === Reading a Pocket Query from file
  #
  #  pq = Geocaching::PocketQuery.from_file("123456.gpx")
  #  puts "The PQ’s name is #{pq.name}."
  #
  class PocketQuery
    # Reads a Pocket Query from file and parses it.  The file may either be a
    # GPX file or a zip file containing the GPX file.
    #
    # @param [String] file File name
    # @return [Geocaching::PocketQuery] Pocket Query
    def self.from_file(file)
      pq = new(:raw => File.read(file))
      pq.parse
      pq
    end

    # Returns an array of Pocket Queries that are ready for download.  You
    # need to be logged in and a Premium Member to use this feature.
    #
    # @return [Array<Geocaching::PocketQuery>]
    #   Array of Pocket Queries ready for download
    def self.ready_for_download
      raise LoginError unless HTTP.loggedin?

      pqs = []
      resp, data = HTTP.get("/pocket/default.aspx")
      doc = Nokogiri::HTML.parse(data)

      elements = doc.search("table#uxOfflinePQTable")
      raise ParseError unless elements.size == 1

      elements = elements.first.search("tr")[1..-1]

      elements.each do |row|
        # Name
        elements = row.search("td:nth-child(3) > a")
        next unless elements.size == 1
        name = elements.first.text.strip

        # GUID
        if elements.first["href"] =~ /g=([a-f0-9-]{36})/
          guid = $1
        else
          next
        end

        # Number of results
        elements = row.search("td:nth-child(5)")
        next unless elements.size == 1
        results = elements.first.text.to_i

        # Last Generated date
        elements = row.search("td:nth-child(6)")
        next unless elements.size == 1
        if elements.first.text =~ /(\d{2})\/(\d{2})\/(\d{4})/
          date = Time.mktime($3, $1, $2)
        end

        if guid and name and results and date
          pq = PocketQuery.new \
            :guid              => guid,
            :name              => name,
            :results           => results,
            :last_generated_at => date
          pqs << pq
        end
      end

      pqs
    end

    class << self
      alias ready ready_for_download
    end

    # Adds the ”My Finds“ Pocket Query to the Queue.
    #
    # @return [void]
    def self.schedule_my_finds
      resp, data = HTTP.post("/pocket/default.aspx", {
        "ctl00$ContentBody$PQListControl1$btnScheduleNow" => "Yes"
      })

      !!(data =~ /Your 'My Finds' Pocket Query has been scheduled to run./)
    end

    # Creates a new instance.  The following attributes may be specified
    # as parameters:
    #
    # * +:guid+ — The Pocket Query’s GUID
    #
    # @param [Hash] attributes A hash of attributes
    # @raise [ArgumentError] Trying to set an unknown attribute
    def initialize(attributes = {})
      attributes.each do |key, value|
        if [:guid, :name, :results, :last_generated_at, :raw].include?(key)
          if key == :last_generated_at and not value.kind_of?(Time)
            raise TypeError, \
              "Attribute `last_generated_at' must be an instance of Time"
          end

          if key == :results and not value.kind_of?(Fixnum)
            raise TypeError, "Attribute `results' must be a number"
          end

          instance_variable_set("@#{key}", value)
        else
          raise ArgumentError, "Trying to set unknown attribute `#{key}'"
        end
      end
    end

    # Returns the Pocket Query’s GUID.
    #
    # @return [String] GUID
    def guid
      @guid
    end

    # Returns the Pocket Query’s name.
    #
    # @return [String] Name
    def name
      @name ||= begin
        @gpx.xpath("/xmlns:gpx/xmlns:name").content if @gpx
      end
    end

    # Returns the date the Pocket Query was last generated at.
    #
    # @return [Time] Last generated date
    def last_generated_at
      @last_generated_at ||= begin
        if @gpx
          # ...
        end
      end
    end

    # Returns the number of results inside the Pocket Query.
    #
    # @return [Fixnum] Number of results
    def results
      @results ||= begin
        @caches.size if @caches
      end
    end

    # Returns the Pocket Query’s raw data.  This may be either zipped data
    # or a GPX document.
    #
    # @return [String] Raw data (zip or gpx)
    def raw
      @raw || begin
        raise NotFetchedError, "You have to download the Pocket Query first"
      end
    end

    # Returns the Nokogiri XML document object for the GPX tree.
    #
    # @return [Nokogiri::XML::Document] Nokogiri XML document
    def gpx
      @gpx || begin
        raise NotFetchedError, "You have to download the Pocket Query first"
      end
    end

    # Downloads and parses the Pocket Query.
    #
    # @return [void]
    def download
      raise LoginError unless HTTP.loggedin?

      resp, @raw = HTTP.get("/pocket/downloadpq.ashx?g=#{guid}")
      parse
    end

  private

    # Parses the Pocket Query’s GPX document.
    #
    # @return [void]
    def parse
      unless @raw
        raise NotFetchedError, "You have to download the Pocket Query first"
      end

      if @raw[0..2] == "PK"
        raise "Support for zip Pocket Query isn’t implemented yet"
      else
        @gpx = Nokogiri::XML.parse(@raw)
      end
    end
  end
end
