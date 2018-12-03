require "json"

module GeoJSON

  class MalformedCoordinateException < Exception
  end

  private abstract class Coordinates(T)
    getter coordinates : Array(T)

    def initialize(@coordinates : Array(T))
    end

    abstract def raise_if_invalid

    delegate to_json, "[]", to: coordinates

    def_equals coordinates

    # We use the inherited macro to create subclass initializers because any
    # subclass initializer will obscure all superclass initializers
    macro inherited
      def initialize(@coordinates : Array(T))
        raise_if_invalid
      end

      def initialize(*coordinates : T)
        initialize coordinates.to_a
      end

      def initialize(parser : JSON::PullParser)
        @coordinates = Array(T).new(parser)

        raise_if_invalid
      end
    end
  end

  class Position < Coordinates(Float64)

    def initialize(coordinates : Array(Number))
      initialize coordinates.map { |number| number.to_f64 }

      raise_if_invalid
    end

    def initialize(*coordinates : Number)
      initialize coordinates.to_a
    end

    def initialize(longitude lon, latitude lat, altivation alt = nil)
      unless alt.nil?
        initialize [lon, lat, alt]
      else
        initialize [lon, lat]
      end
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

  class LineStringCoordinates < Coordinates(Position)

    def initialize(arrays : Array(Array))
      initialize arrays.map { |array| Position.new(array)}
    end

    def initialize(*arrays : Array)
      initialize arrays.to_a
    end

    private def raise_if_invalid
      if coordinates.size < 2
        raise MalformedCoordinateException.new("LineString must have two or more points!")
      end
    end
  end

  class LinearRing < LineStringCoordinates
    private def raise_if_invalid
      if coordinates.size < 4
        raise MalformedCoordinateException.new("LinearRing must have four or more points!")
      end

      if coordinates.first != coordinates.last
        raise MalformedCoordinateException.new("LinearRing must have matching first and last points!")
      end
    end
  end

  class PolyRings < Coordinates(LinearRing)

    def initialize(arrays : Array(Array))
      initialize arrays.map { |array| LinearRing.new array }
    end

    def initialize(*arrays : Array)
      initialize arrays.to_a
    end

    def raise_if_invalid
    end
  end

end
