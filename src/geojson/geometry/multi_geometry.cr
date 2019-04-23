module GeoJSON
  # A `MultiGeometry` is a `Geometry` corresponding to a "normal geometry" type
  # *T* and which can contain multiple coordinates of type *E*.
  module MultiGeometry(T, E)
    # Returns an array of this geometry's coordinates.
    getter coordinates : Array(E)

    # Creates a new geometry with the given *coordinates*.
    def initialize(coordinates : Array(T))
      @coordinates = coordinates.map { |coordinate| coordinate.coordinates }.to_a
    end

    # :ditto:
    def initialize(@coordinates : Array(E))
    end

    # Creates a new geometry with coordinates based on the given
    # *coordinate_tree*.
    def initialize(coordinate_tree : CoordinateTree)
      @coordinates = coordinate_tree.map { |child| E.new child }
    end

    # Gets a new `T` from the coordinates at the given index.
    def [](index : Int)
      T.new coordinates[index]
    end
  end
end
