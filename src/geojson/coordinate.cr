require "json"

module GeoJSON

  class MalformedCoordinateException < Exception
  end

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
    # TODO: give this a better name

    getter coordinates : Array(Position)

    def initialize(points : Array(Position))
      unless points.size < 2
        @coordinates = points
      else
        raise MalformedCoordinateException("LineString must have two or more points!")
      end
    end

    def initialize(*points : Position)
      initialize points.to_a
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Position).new(parser)
    end

    def [](index : Int)
      coordinates[index]
    end

    def ==(other : self)
      coordinates == other.coordinates
    end

    delegate to_json, to: coordinates

  end

  class LinearRing < LineStringCoordinates
    # TODO: implement right-hand rule checking

    def initialize(points : Array(Position))
      if points.size >= 4 && points.first == points.last
        @coordinates = points
      elsif points.size >= 4
        raise MalformedCoordinateException.new("LinearRing must have matching first and last points!")
      else
        raise MalformedCoordinateException.new("LinearRing must have four or more points!")
      end
    end

    def initialize(*points : Position)
      initialize points.to_a
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Position).new(parser)
    end
  end

end
