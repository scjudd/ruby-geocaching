# encoding: utf-8

module Geocaching
  # The {CacheType} class represents a cache type.
  #
  # == Usage
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

    # Returns a {CacheType} object for the given cache type id, or
    # nil if no appropriate cache id is found.
    #
    # @return [Geocaching::CacheType]
    # @return [nil] If no appropriate cache type is found
    def self.for_id(id)
      if info = TYPES.to_a.select { |(k,v)| v[0] == id } and info.size == 1
        new(info.first)
      end
    end

    # Returns a {CacheType} object for the given cache type title, or
    # nil if no appropriate cache type is found.
    #
    # @return [Geocaching::CacheType]
    # @return [nil] If no appropriate cache type is found
    def self.for_title(title)
      if info = TYPES.to_a.select { |(k,v)| v[1] == title } and info.size == 1
        new(info.first)
      end
    end

    # Creates a new instance.  You should not need to create an instance
    # of this class on your own.  Use {for_id} and {for_title}.
    def initialize(info)
      @info = info
    end

    # Returns the cache type’s ID.
    #
    # @return [Fixnum] Cache type ID
    def id
      @info[1][0]
    end

    # Returns the cache type’s name.
    #
    # @return [String] Cache type name
    def name
      @info[1][1]
    end

    alias to_s name

    # Returns the symbol that describes this cache type.  See the {TYPES}
    # hash for a list of cache type symbols.
    #
    # @return [Symbol] Cache type symbol
    def to_sym
      @info[0]
    end

    # Overloads the +==+ operator to compare by symbol.
    #
    #  if @cache.type == :multi
    #    puts "It's a multi cache."
    #  end
    #
    # @return [Boolean] Does object match with argument?
    def ==(s)
      to_sym == s
    end
  end
end
