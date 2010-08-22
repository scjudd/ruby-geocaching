module Geocaching
  # This class represents a log type.
  #
  #  if @log.type == :archive
  #    puts "#{@log.cache.code} has been archived"
  #  end
  class LogType
    # Mapping of log types to their corresponding icon and title
    # on geocaching.com.
    TYPES = {
      :publish            => ["icon_greenlight",    "Publish Listing"],
      :retract            => ["icon_redlight",      "Retract Listing"],
      :dnf                => ["icon_sad",           "Didn't find it"],
      :found              => ["icon_smile",         "Found it"],
      :webcam_photo_taken => ["icon_camera",        "Webcam Photo Taken"],
      :will_attend        => ["icon_rsvp",          "Will Attend"],
      :announcement       => ["icon_announcement",  "Announcement"],
      :attended           => ["icon_attended",      "Attended"],
      :needs_maintenance  => ["icon_needsmaint",    "Needs Maintenance"],
      :owner_maintenance  => ["icon_maint",         "Owner Maintenance"],
      :disable            => ["icon_disabled",      "Temporarily Disable Listing"],
      :enable             => ["icon_enabled",       "Enable Listing"],
      :note               => ["icon_note",          "Write note"],
      :needs_archived     => ["icon_remove",        "Needs Archived"],
      :archive            => ["traffic_cone",       "Archive"],
      :unarchive          => ["traffic_cone",       "Unarchive"],
      :coords_update      => ["coord_update",       "Update Coordinates"],
      :reviewer_note      => ["big_smile",          "Post Reviewer Note"]
    }

    # Return a {LogType} object for the given log type icon, or nil if
    # no appropriate log type is found.
    #
    # @return [Geocaching::LogType]
    # @return [nil] If no appropriate log type is found
    def self.for_icon(icon)
      if info = TYPES.to_a.select { |(k,v)| v[0] == icon } and info.size == 1
        new(info.first)
      end
    end

    # Return a {LogType} object for the given log type title, or nil if
    # no appropriate log type is found.
    #
    # @return [Geocaching::LogType]
    # @return [nil] If no appropriate log type is found
    def self.for_title(title)
      if info = TYPES.to_a.select { |(k,v)| v[1] == title } and info.size == 1
        new(info.first)
      end
    end

    # Create a new instance. You should not need to create an instance
    # of this class on your own. Use {for_icon} and {for_title}.
    def initialize(info)
      @info = info
    end

    # Return the log type’s icon.
    #
    # @return [String]
    def icon
      @info[1][0]
    end

    # Return the log type’s title.
    #
    # @return [String]
    def description
      @info[1][1]
    end

    alias to_s description

    # Return the symbol representatin of the log type. See the {TYPES}
    # hash for a list of log type symbols.
    #
    # @return [Symbol]
    def to_sym
      @info[0]
    end

    # Overload the == operator.
    #
    #  if @log.type == :dnf
    #    puts "Someone could not find the cache"
    #  end
    #
    # @return [Boolean]
    def ==(s)
      to_sym == s
    end
  end
end
