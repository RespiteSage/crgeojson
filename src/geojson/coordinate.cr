require "json"

module GeoJSON

  class MalformedCoordinateException < Exception
  end

  abstract class Coordinates
    abstract def coordinates : Array

    def ==(other : self)
      coordinates == other.coordinates
    end

    def [](index : Int)
      coordinates[index]
    end

    delegate to_json, to: coordinates
  end

  class Position < Coordinates

    getter coordinates : Array(Float64)

    def initialize(longitude, latitude, altivation = nil)
      unless altivation.nil?
        @coordinates = [longitude.to_f64, latitude.to_f64, altivation.to_f64]
      else
        @coordinates = [longitude.to_f64, latitude.to_f64]
      end
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Float64).new(parser)
    end

    def longitude
      coordinates[0]
    end

    def latitude
      coordinates[1]
    end

    def altivation
      coordinates[2]?
    end

  end

  class LineStringCoordinates < Coordinates
    # TODO: give this a better name

    getter coordinates : Array(Position)

    def initialize(points : Array(Position))
      unless points.size < 2
        @coordinates = points
      else
        raise MalformedCoordinateException.new("LineString must have two or more points!")
      end
    end

    def initialize(*points : Position)
      initialize points.to_a
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Position).new(parser)
    end
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

  class PolyRings < Coordinates

    getter coordinates : Array(LinearRing)

    def initialize(rings : Array(LinearRing))
      @coordinates = rings
    end

    def initialize(*rings : LinearRing)
      initialize rings.to_a
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(LinearRing).new(parser)
    end
  end

end
