require "json"

module GeoJSON
  # TODO
  class MalformedCoordinateException < Exception
  end

  # TODO
  private abstract class Coordinates(T)
    # TODO
    getter coordinates : Array(T)

    # TODO
    def initialize(@coordinates : Array(T))
    end

    # TODO
    abstract def raise_if_invalid

    delegate to_json, "[]", to: coordinates

    def_equals_and_hash coordinates

    # We use the inherited macro to create subclass initializers because any
    # subclass initializer will obscure all superclass initializers
    macro inherited
      # TODO
      def initialize(@coordinates : Array(T))
        raise_if_invalid
      end

      # TODO
      def initialize(*coordinates : T)
        initialize coordinates.to_a
      end

      # TODO
      def initialize(parser : JSON::PullParser)
        @coordinates = Array(T).new(parser)

        raise_if_invalid
      end

      # TODO
      def initialize(coordinate_tree : CoordinateTree)
        @coordinates = coordinate_tree.children.map { |child| T.new child }
      end
    end
  end

  # TODO
  class Position < Coordinates(Float64)
    # TODO
    def initialize(coordinates : Array(Number))
      initialize coordinates.map { |number| number.to_f64 }

      raise_if_invalid
    end

    # TODO
    def initialize(longitude lon, latitude lat, altivation alt = nil)
      unless alt.nil?
        initialize [lon, lat, alt]
      else
        initialize [lon, lat]
      end
    end

    # TODO
    def initialize(coordinate_tree : CoordinateTree)
      initialize coordinate_tree.children.flat_map { |child| child.leaf_value}
    end

    # TODO
    def longitude
      coordinates[0]
    end

    # TODO
    def latitude
      coordinates[1]
    end

    # TODO
    def altivation
      coordinates[2]?
    end

    # TODO
    private def raise_if_invalid
      if coordinates.size < 2 || coordinates.size > 3
        raise MalformedCoordinateException.new "Position must have two or three coordinates!"
      end
    end
  end

  # TODO
  class LineStringCoordinates < Coordinates(Position)
    # TODO
    def initialize(arrays : Array(Array))
      initialize arrays.map { |array| Position.new(array) }
    end

    # TODO
    def initialize(*arrays : Array)
      initialize arrays.to_a
    end

    # TODO
    private def raise_if_invalid
      if coordinates.size < 2
        raise MalformedCoordinateException.new("LineString must have two or more points!")
      end
    end

    # TODO
    def ==(other : LineStringCoordinates)
      self.coordinates == other.coordinates
    end
  end

  # TODO
  class LinearRing < LineStringCoordinates
    # TODO
    private def raise_if_invalid
      if coordinates.size < 4
        raise MalformedCoordinateException.new("LinearRing must have four or more points!")
      end

      if coordinates.first != coordinates.last
        raise MalformedCoordinateException.new("LinearRing must have matching first and last points!")
      end
    end
  end

  # TODO
  class PolyRings < Coordinates(LinearRing)
    # TODO
    def initialize(arrays : Array(Array))
      initialize arrays.map { |array| LinearRing.new array }
    end

    # TODO
    def initialize(*arrays : Array)
      initialize arrays.to_a
    end

    # TODO
    def raise_if_invalid
    end
  end
end
