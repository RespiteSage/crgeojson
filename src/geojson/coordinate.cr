require "json"

module GeoJSON
  # A `MalformedCoordinateException` indicates when coordinates have been
  # improperly constructed or modified.
  class MalformedCoordinateException < Exception
  end

  # A `Coordinates(T)` represents coordinates in a GeoJSON geometry. It provides
  # several constructors and a `#[]` accessor.
  #
  # Subclasses must implement `#raise_if_invalid`, which is meant to raise a
  # `MalformedCoordinateException` if the coordinates are malformed.
  private abstract class Coordinates(T)
    # Gets the actual coordinates array of these `Coordinates`.
    getter coordinates : Array(T)

    # :nodoc:
    # This initializer is only here to satisfy the compiler (so that
    # `coordinates` is properly initialized).
    def initialize(@coordinates : Array(T))
    end

    # Raises a `MalformedCoordinateException` if these coordinates are
    # invalid.
    abstract def raise_if_invalid

    delegate to_json, "[]", to: coordinates

    def_equals_and_hash coordinates

    # We use the inherited macro to create subclass initializers because any
    # subclass initializer will obscure all superclass initializers.
    macro inherited
      # Creates new `Coordinates` backed by the given *coordinates*.
      def initialize(@coordinates : Array(T))
        raise_if_invalid
      end

      # Creates new `Coordinates` with the values from the given *coordinates*.
      def initialize(*coordinates : T)
        initialize coordinates.to_a
      end

      # Creates new `Coordinates` using the given *parser*.
      def initialize(parser : JSON::PullParser)
        @coordinates = Array(T).new(parser)

        raise_if_invalid
      end

      # Creates new `Coordinates` from the given *coordinate_tree*. The tree's
      # structure is assumed to be correct for the particular kind of
      # `Coordinates` that are being created.
      def initialize(coordinate_tree : CoordinateTree)
        @coordinates = coordinate_tree.children.map { |child| T.new child }
      end
    end
  end

  # A `Position` represents a position on earth with a longitude, latitude, and
  # optional altitude/elevation (`#altivation`).
  class Position < Coordinates(Float64)
    # Creates a new `Coordinates` with the values from the given *coordinates*.
    def initialize(coordinates : Array(Number))
      initialize coordinates.map { |number| number.to_f64 }

      raise_if_invalid
    end

    # Creates a new `Position` with the given *longitude*, *latitude*, and
    # *altivation*.
    def initialize(longitude lon, latitude lat, altivation alt = nil)
      unless alt.nil?
        initialize [lon, lat, alt]
      else
        initialize [lon, lat]
      end
    end

    # Creates a new `Position` from the given *coordinate_tree*.
    def initialize(coordinate_tree : CoordinateTree)
      initialize coordinate_tree.children.map { |child| child.leaf_value}
    end

    # Returns the longitude of this `Position`.
    #
    # The first coordinate of this `Position` is assumed to be the longitude.
    def longitude
      coordinates[0]
    end

    # Returns the latitude of this `Position`.
    #
    # The second coordinate of this `Position` is assumed to be the latitude.
    def latitude
      coordinates[1]
    end

    # Returns the altivation (altitude or elevation) of this `Position`.
    #
    # The third coordinate of this `Position` is assumed to be the altivation.
    def altivation
      coordinates[2]?
    end

    # Raises a `MalformedCoordinateException` if this `Position` has fewer than
    # two or more than three coordinate values.
    private def raise_if_invalid
      if coordinates.size < 2 || coordinates.size > 3
        raise MalformedCoordinateException.new "Position must have two or three coordinates!"
      end
    end
  end

  # `LineStringCoordinates` represent multiple positions connected by lines.
  # They must contain at least two `Position` coordinates.
  class LineStringCoordinates < Coordinates(Position)
    # Creates new `LineStringCoordinates` from the given *arrays*.
    def initialize(arrays : Array(Array))
      initialize arrays.map { |array| Position.new(array) }
    end

    # Creates a new `LineStringCoordinates` from the given *arrays*.
    def initialize(*arrays : Array)
      initialize arrays.to_a
    end

    # Raises a `MalformedCoordinateException` if these `LineStringCoordinates`
    # have fewer than two positions.
    private def raise_if_invalid
      if coordinates.size < 2
        raise MalformedCoordinateException.new("LineString must have two or more points!")
      end
    end

    # Returns true if the *other* `LineStringCoordinates` have the same
    # coordinates as these `LineStringCoordinates`.
    def ==(other : LineStringCoordinates)
      self.coordinates == other.coordinates
    end
  end

  # A `LinearRing` is a closed set of `LineStringCoordinates`. To satisfy this
  # requirement, it must consist of at least four postions, and the first and
  # last positions must be the same.
  class LinearRing < LineStringCoordinates
    # Raises a `MalformedCoordinateException` if this `LinearRing` has fewer than
    # four coordinates or if its first and last positions are not equal.
    private def raise_if_invalid
      if coordinates.size < 4
        raise MalformedCoordinateException.new("LinearRing must have four or more points!")
      end

      if coordinates.first != coordinates.last
        raise MalformedCoordinateException.new("LinearRing must have matching first and last points!")
      end
    end
  end

  # A `PolyRings` represents a collection of `LinearRing` coordinates. There are
  # no validity restrictions on how many `LinearRing` coordinates may be in a
  # `PolyRings`.
  class PolyRings < Coordinates(LinearRing)
    # Creates new `PolyRings` from the given *arrays*.
    def initialize(arrays : Array(Array))
      initialize arrays.map { |array| LinearRing.new array }
    end

    # Creates a new `PolyRings` from the given *arrays*.
    def initialize(*arrays : Array)
      initialize arrays.to_a
    end

    # Never raises.
    def raise_if_invalid
    end
  end
end
