module Geocaching
  class CacheType
    TYPES = {
      :traditional  => [2, "Traditional Cache"],
      :multi        => [3, "Multi Cache"],
      :mystery      => [8, "Mystery Cache"],
      :letterbox    => [5, "Letterbox Hybrid"],
      :wherigo      => [1858, "Wherigo"],
      :event        => [6, "Event Cache"],
      :megaevent    => [453, "Mega Event Cache"],
      :cito         => [13, "Cache In Trash Out Event"],
      :earthcache   => [137, "EarthCache"],
      :lfevent      => [3653, "Lost and Found Event Cache"],
      :locationless => [12, "Locationless Reverse Cache"],
      :webcam       => [11, "Webcam Cache"],
      :virtual      => [4, "Virtual Cache"],
      :ape          => [32, "Project A.P.E. Cache"] # XXX
    }

    def self.for_id(id)
      if info = TYPES.to_a.select { |(k,v)| v[0] == id } and info.size == 1
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

    def to_sym
      @info[0]
    end

    def ==(s)
      to_sym == s
    end
  end
end
