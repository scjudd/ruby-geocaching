module Geocaching
  class CacheType
    TYPES = {
      :traditional  => [2,    "Traditional Cache"],
      :multi        => [3,    "Multi-cache"],
      :mystery      => [8,    "Unknown Cache"],
      :letterbox    => [5,    "Letterbox Hybrid"],
      :wherigo      => [1858, "Wherigo Cache"],
      :event        => [6,    "Event Cache"],
      :megaevent    => [453,  "Mega-Event Cache"],
      :cito         => [13,   "Cache In Trash Out Event"],
      :earthcache   => [137,  "Earthcache"],
      :lfevent      => [3653, "Lost and Found Event Cache"],
      :locationless => [12,   "Locationless (Reverse) Cache"],
      :webcam       => [11,   "Webcam Cache"],
      :virtual      => [4,    "Virtual Cache"],
      :ape          => [9,    "Project APE Cache"]
    }

    def self.for_id(id)
      if info = TYPES.to_a.select { |(k,v)| v[0] == id } and info.size == 1
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

    def id
      @info[1][0]
    end

    def name
      @info[1][1]
    end

    def to_s
      name
    end

    def to_sym
      @info[0]
    end

    def ==(s)
      to_sym == s
    end
  end
end
