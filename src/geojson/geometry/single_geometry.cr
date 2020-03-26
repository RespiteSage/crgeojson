require "../coordinates/coordinate_tree"

module GeoJSON
  # A `SingleGeometry` is a `Geometry` with a single `Coordinates` member of
  # type *T*.
  module SingleGeometry(T)
    # Returns this geometry's coordinates.
    getter coordinates : T

    # Create a new geometry with the given *coordinates*.
    def initialize(@coordinates : T)
    end

    # Create a new geometry with coordinates created from the given
    # *coordinates* array.
    def initialize(coordinates : Array)
      @coordinates = T.new coordinates
    end

    # Create a new geometry from the given *coordinates* CoordinateTree.
    def initialize(coordinates : CoordinateTree)
      @coordinates = T.new coordinates
    end
  end
end
