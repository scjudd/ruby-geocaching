module Geocaching
  class LogType
    TYPES = {
      :publish            => ["icon_greenlight", "Publish Listing"],
      :retract            => ["icon_redlight", "Retract Listing"],
      :dnf                => ["icon_sad", "Didn't find it"],
      :found              => ["icon_smile", "Found it"],
      :webcam_photo_taken => ["icon_camera", "Webcam Photo Taken"],
      :will_attend        => ["icon_rsvp", "Will Attend"],
      :announcement       => ["icon_announcement", "Announcement"],
      :attended           => ["icon_attended", "Attended"],
      :needs_maintenance  => ["icon_needsmaint", "Needs Maintenance"],
      :owner_maintenance  => ["icon_maint", "Owner Maintenance"],
      :disable            => ["icon_disabled", "Temporarily Disable Listing"],
      :enable             => ["icon_enabled", "Enable Listing"],
      :note               => ["icon_note", "Write note"],
      :needs_archived     => ["icon_remove", "Needs Archived"],
      :archive            => ["traffic_cone", "Archive"],
      :unarchive          => ["traffic_cone", "Unarchive"],
      :coords_update      => ["coord_update", "Update Coordinates"],
      :reviewer_note      => ["big_smile", "Post Reviewer Note"]
    }

    def self.for_icon(icon)
      if info = TYPES.to_a.select { |(k,v)| v[0] == icon } and info.size == 1
        new(info.first)
      end
    end

    def self.for_title(title)
      if info = TYPES.to_a.select { |(k,v)| v[1] == title } and info.size == 1
        new(info.first)
      end
    end

    def initialize(info)
      @info = info
    end

    def icon
      @info[1][0]
    end

    def description
      @info[1][1]
    end

    def to_sym
      @info[0]
    end

    def ==(s)
      to_sym == s
    end
  end
end
