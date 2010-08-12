require "time"

module Geocaching
  class User
    def self.fetch(attributes)
      user = new(attributes)
      user.fetch
      user
    end

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

    def fetch
      raise ArgumentError, "No GUID given" unless @guid

      resp, @data = HTTP.get(path)
      @doc = Nokogiri::HTML.parse(@data)
    end

    def fetched?
      @data and @doc
    end

    def guid
      @guid
    end

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

    def homepage
      @homepage ||= begin
        raise NotFetchedError unless fetched?

        elements = @doc.search("#ctl00_ContentBody_ProfilePanel1_lnkHomePage")
        elements.first["href"] if elements.size == 1
      end
    end

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

    def reviewer?
      status.include?("Reviewer")
    end

    def premium_member?
      status.include?("Premium Member")
    end

  private

    def path
      "/profile/?guid=#{guid}"
    end
  end
end
