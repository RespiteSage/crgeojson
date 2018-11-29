require "json"

module GeoJSON

  class MalformedCoordinateException < Exception
  end

  private abstract class Coordinates
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

    def initialize(coordinates : Array(Number))
      @coordinates = coordinates.map { |number| number.to_f64 }

      raise_if_invalid
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Float64).new(parser)

      raise_if_invalid
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

    private def raise_if_invalid
      if coordinates.size < 2 || coordinates.size > 3
        raise MalformedCoordinateException.new "Position must have two or three coordinates!"
      end
    end
  end

  class LineStringCoordinates < Coordinates
    getter coordinates : Array(Position)

    def initialize(points : Array(Position))
      @coordinates = points

      raise_if_invalid
    end

    def initialize(*points : Position)
      initialize points.to_a
    end

    def initialize(arrays : Array(Array))
      @coordinates = arrays.map { |array| Position.new(array)}

      raise_if_invalid
    end

    def initialize(*arrays : Array)
      initialize arrays.to_a
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Position).new(parser)

      raise_if_invalid
    end

    private def raise_if_invalid
      if coordinates.size < 2
        raise MalformedCoordinateException.new("LineString must have two or more points!")
      end
    end
  end

  class LinearRing < LineStringCoordinates
    def initialize(points : Array(Position))
      @coordinates = points

      raise_if_invalid
    end

    def initialize(*points : Position)
      initialize points.to_a
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Position).new(parser)

      raise_if_invalid
    end

    def initialize(arrays : Array(Array))
      super
    end

    def initialize(*arrays : Array)
      super
    end

    private def raise_if_invalid
      if coordinates.size < 4
        raise MalformedCoordinateException.new("LinearRing must have four or more points!")
      end

      if coordinates.first != coordinates.last
        raise MalformedCoordinateException.new("LinearRing must have matching first and last points!")
      end
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

    def initialize(arrays : Array(Array))
      @coordinates = arrays.map { |array| LinearRing.new array }
    end

    def initialize(*arrays : Array)
      initialize arrays.to_a
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(LinearRing).new(parser)
    end
  end

end
