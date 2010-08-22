require "time"

module Geocaching
  # This class represents an user on geocaching.com.
  #
  #  user = Geocaching::User.fetch(:guid => "...")
  #  puts user.name #=> "Jack"
  class User
    # Create a new instance and call the {fetch} method afterwards.
    # +:guid+ must be giveb as an attribute.
    #
    # @param [Hash] attributes A hash of attributes
    # @raise [ArgumentError] No GUID given
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @return [Geocaching::User]
    def self.fetch(attributes)
      user = new(attributes)
      user.fetch
      user
    end

    # Create a new instance. The following attributes may be specified
    # as parameters:
    #
    # * +:guid+ — The user’s Globally Unique Identifier (GUID)
    #
    # @param [Hash] attributes A hash of attributes
    # @raise [ArgumentError] Trying to set an unknown attribute
    def initialize(attributes = {})
      @data, @doc, @guid = nil, nil, nil

      attributes.each do |key, value|
        if [:guid].include?(key)
          instance_variable_set("@#{key}", value)
        else
          raise ArgumentError, "Trying to set unknown attribute `#{key}'"
        end
      end
    end

    # Fetch user information from geocaching.com.
    #
    # @return [void]
    # @raise [ArgumentError] No GUID given
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    def fetch
      raise ArgumentError, "No GUID given" unless @guid

      resp, @data = HTTP.get(path)
      @doc = Nokogiri::HTML.parse(@data)
    end

    # Return whether user information have successfully been fetched
    # from geocaching.com.
    #
    # @return [Boolean]
    def fetched?
      @data and @doc
    end

    # Return the user’s Globally Unique Identifier (GUID).
    #
    # @return [String]
    def guid
      @guid
    end

    # Return the user’s name.
    #
    # @return [String]
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @raise [Geocaching::ExtractError] Could not extract name from website
    def name
      @name ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_lblUserProfile")

        if elements.size == 1 and elements.first.content =~ /Profile for User|Reviewer: (.+)/
          HTTP.unescape($1)
        else
          raise ExtractError, "Could not extract name from website"
        end
      end
    end

    # Return the user’s occupation.
    #
    # @return [String]
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @raise [Geocaching::ExtractError] Could not extract information from website
    def occupation
      @occupation ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblOccupationTxt")

        if elements.size == 1
          HTTP.unescape(elements.first.content)
        else
          raise ExtractError, "Could not extract occupation from website"
        end
      end
    end

    # Return the user’s location.
    #
    # @return [String]
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @raise [Geocaching::ExtractError] Could not extract information from website
    def location
      @location ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblLocationTxt")

        if elements.size == 1
          HTTP.unescape(elements.first.content)
        else
          raise ExtractError, "Could not extract location from website"
        end
      end
    end

    # Return the user’s forum title.
    #
    # @return [String]
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @raise [Geocaching::ExtractError] Could not extract information from website
    def forum_title
      @forum_title ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblForumTitleTxt")

        if elements.size == 1
          HTTP.unescape(elements.first.content)
        else
          raise ExtractError, "Could not extract forum title from website"
        end
      end
    end

    # Return the user’s homepage.
    #
    # @return [String]
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @raise [Geocaching::ExtractError] Could not extract information from website
    def homepage
      @homepage ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lnkHomePage")
        elements.first["href"] if elements.size == 1
      end
    end

    # Return the user’s statuses.
    #
    # @return [Array<String>]
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @raise [Geocaching::ExtractError] Could not extract information from website
    def status
      @status ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblStatusText")

        if elements.size == 1
          HTTP.unescape(elements.first.content).split(",").map(&:strip)
        else
          raise ExtractError, "Could not extract status from website"
        end
      end
    end

    # Return the user’s last visit date.
    #
    # @return [Time]
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @raise [Geocaching::ExtractError] Could not extract information from website
    def last_visit
      @last_visit ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblLastVisitDate")

        if elements.size == 1
          Time.parse(elements.first.content)
        else
          raise ExtractError, "Could not extract last visit date from website"
        end
      end
    end

    # Return the user’s member since date.
    #
    # @return [Time]
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @raise [Geocaching::ExtractError] Could not extract information from website
    def member_since
      @member_since ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblMemberSinceDate")

        if elements.size == 1
          Time.parse(elements.first.content)
        else
          raise ExtractError, "Could not extract member since date from website"
        end
      end
    end

    # Return whether the user is a reviewer.
    #
    # @return [Boolean]
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @raise [Geocaching::ExtractError] Could not extract information from website
    def reviewer?
      status.include?("Reviewer")
    end

    # Return whether the user is a premium member.
    #
    # @return [Boolean]
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    # @raise [Geocaching::ExtractError] Could not extract information from website
    def premium_member?
      status.include?("Premium Member")
    end

  private

    def path
      "/profile/?guid=#{guid}"
    end
  end
end
