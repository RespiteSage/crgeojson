require "json"

module GeoJSON::Coordinates
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
        @coordinates = coordinate_tree.map { |child| T.new child }
      end
    end
  end
end
