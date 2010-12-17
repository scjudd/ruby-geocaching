# encoding: utf-8

require "time"

module Geocaching
  # The {User} class represents a user on geocaching.com.
  #
  # == Usage
  #
  #  user = Geocaching::User.fetch(:guid => "...")
  #  puts user.name #=> "Jack"
  #
  class User
    # Creates a new instance and calls the {fetch} method afterwards.
    # +:guid+ must be given as an attribute.
    #
    # @param [Hash] attributes A hash of attributes
    # @raise [ArgumentError] No GUID given
    # @return [Geocaching::User]
    def self.fetch(attributes)
      user = new(attributes)
      user.fetch
      user
    end

    # Creates a new instance.  The following attributes may be specified
    # as parameters:
    #
    # * +:guid+ — The user’s Globally Unique Identifier (GUID)
    # * +:name+ — The user‘s name
    #
    # @param [Hash] attributes A hash of attributes
    # @raise [ArgumentError] Trying to set an unknown attribute
    def initialize(attributes = {})
      @data, @doc, @guid = nil, nil, nil

      attributes.each do |key, value|
        if [:guid, :name].include?(key)
          instance_variable_set("@#{key}", value)
        else
          raise ArgumentError, "Trying to set unknown attribute `#{key}'"
        end
      end
    end

    # Fetches user information from geocaching.com.
    #
    # @return [void]
    # @raise [ArgumentError] No GUID given
    def fetch
      raise ArgumentError, "No GUID given" unless @guid

      resp, @data = HTTP.get("/profile/?guid=#{guid}")
      @doc = Nokogiri::HTML.parse(@data)
    end

    # Returns whether user information have successfully been fetched
    # from geocaching.com.
    #
    # @return [Boolean] Have user information been fetched?
    def fetched?
      @data and @doc
    end

    # Returns the user’s Globally Unique Identifier (GUID).
    #
    # @return [String]
    def guid
      @guid
    end

    # Returns the user’s name.
    #
    # @return [String]
    def name
      @name ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_lblUserProfile")

        if elements.size == 1 and elements.first.content =~ /Profile for User|Reviewer: (.+)/
          HTTP.unescape($1)
        else
          raise ParseError, "Could not extract name from website"
        end
      end
    end

    # Returns the user’s occupation.
    #
    # @return [String] Occupation
    def occupation
      @occupation ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblOccupationTxt")

        if elements.size == 1
          HTTP.unescape(elements.first.content)
        else
          raise ParseError, "Could not extract occupation from website"
        end
      end
    end

    # Returns the user’s location.
    #
    # @return [String] Location
    def location
      @location ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblLocationTxt")

        if elements.size == 1
          HTTP.unescape(elements.first.content)
        else
          raise ParseError, "Could not extract location from website"
        end
      end
    end

    # Returns the user’s forum title.
    #
    # @return [String] Forum title
    def forum_title
      @forum_title ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblForumTitleTxt")

        if elements.size == 1
          HTTP.unescape(elements.first.content)
        else
          raise ParseError, "Could not extract forum title from website"
        end
      end
    end

    # Returns the user’s homepage.
    #
    # @return [String] Homepage
    def homepage
      @homepage ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lnkHomePage")
        elements.first["href"] if elements.size == 1
      end
    end

    # Returns the user’s statuses.
    #
    # @return [Array<String>] Array of statuses
    def status
      @status ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblStatusText")

        if elements.size == 1
          HTTP.unescape(elements.first.content).split(",").map(&:strip)
        else
          raise ParseError, "Could not extract status from website"
        end
      end
    end

    # Returns the user’s last visit date.
    #
    # @return [Time] Last visit date
    def last_visit
      @last_visit ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblLastVisitDate")

        if elements.size == 1
          Time.parse(elements.first.content)
        else
          raise ParseError, "Could not extract last visit date from website"
        end
      end
    end

    # Returns the user’s member since date.
    #
    # @return [Time] Member since date
    def member_since
      @member_since ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lblMemberSinceDate")

        if elements.size == 1
          Time.parse(elements.first.content)
        else
          raise ParseError, "Could not extract member since date from website"
        end
      end
    end

    # Returns whether the user is a reviewer.
    #
    # @return [Boolean] Is user a reviewer?
    def reviewer?
      status.include?("Reviewer")
    end

    # Returns whether the user is a Premium Member.
    #
    # @return [Boolean] Is user a Premium Member?
    def premium_member?
      status.include?("Premium Member")
    end
  end
end
