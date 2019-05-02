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

    # Creates new `Coordinates` backed by the given *coordinates*.
    def initialize(@coordinates : Array(T))
      raise_if_invalid
    end

    # Creates a new `Coordinates` that is a copy of the *other* `Coordinates`.
    def initialize(other : self)
      @coordinates = other.coordinates.clone

      raise_if_invalid
    end

    # Creates a new `Coordinates` from the given *coordinates* array.
    def initialize(coordinates : Array)
      @coordinates = coordinates.map { |coord| T.new coord }

      raise_if_invalid
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

      raise_if_invalid
    end

    # Creates a copy of these `Coordinates`.
    def clone
      self.class.new self
    end

    # Raises a `MalformedCoordinateException` if these coordinates are
    # invalid.
    abstract def raise_if_invalid

    delegate to_json, "[]", to: coordinates

    def_equals_and_hash coordinates
  end
end
