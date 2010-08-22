module Geocaching
  # This class represents a cache type.
  #
  #  if @cache.type == :traditional
  #    puts "Cache is a Traditional Cache"
  #  end
  class CacheType
    # A mapping of cache types to their corresponding ID and name
    # on geocaching.com.
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

    # Return a {CacheType} object for the given cache type id, or
    # nil if no appropriate cache id is found.
    #
    # @return [Geocaching::CacheType]
    # @return [nil] If no appropriate cache type is found
    def self.for_id(id)
      if info = TYPES.to_a.select { |(k,v)| v[0] == id } and info.size == 1
        new(info.first)
      end
    end

    # Return a {CacheType} object for the given cache type title, or
    # nil if no appropriate cache type is found.
    #
    # @return [Geocaching::CacheType]
    # @return [nil] If no appropriate cache type is found
    def self.for_title(title)
      if info = TYPES.to_a.select { |(k,v)| v[1] == title } and info.size == 1
        new(info.first)
      end
    end

    # Create a new instance. You should not need to create an instance
    # of this class on your own. Use {for_id} and {for_title}.
    def initialize(info)
      @info = info
    end

    # Return the cache type’s ID.
    #
    # @return [Fixnum]
    def id
      @info[1][0]
    end

    # Return the cache type’s name.
    #
    # @return [String]
    def name
      @info[1][1]
    end

    alias to_s name

    # Return the symbol that describes this cache type. See the {TYPES}
    # hash for a list of cache type symbols.
    #
    # @return [Symbol]
    def to_sym
      @info[0]
    end

    # Overload the == operator.
    #
    #  if @cache.type == :multi
    #    puts "It's a multi cache."
    #  end
    #
    # @return [Boolean]
    def ==(s)
      to_sym == s
    end
  end
end
