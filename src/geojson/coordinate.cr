require "json"

module GeoJSON

  class Position

    getter coordinates : Array(Float64)

    def initialize(longitude, latitude)
      @coordinates = [longitude.to_f64, latitude.to_f64]
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Float64).new(parser)
    end

    def lon
      coordinates[0]
    end

    def lat
      coordinates[1]
    end

    def ==(other : Position)
      coordinates == other.coordinates
    end

    delegate to_json, to: coordinates
  end

  class LineStringCoordinates

    getter coordinates : Array(Position)

    def initialize(*points : Position)
      unless points.size < 2
        @coordinates = points.to_a
      else
        raise "LineString must have two or more points!"
      end
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Position).new(parser)
    end

    def [](index : Int)
      coordinates[index]
    end

    def ==(other : LineStringCoordinates)
      coordinates == other.coordinates
    end

    delegate to_json, to: coordinates

  end

end
