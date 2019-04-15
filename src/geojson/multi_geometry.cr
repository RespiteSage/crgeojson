require "json"

module GeoJSON
  # A `MultiGeometry` is a `Geometry` corresponding to a "normal geometry" type
  # *T* and which can contain multiple coordinates of type *E*.
  module MultiGeometry(T, E)
    # Returns an array of this geometry's coordinates.
    getter coordinates : Array(E)

    # Creates a new geometry with the given *coordinates*.
    def initialize(*coordinates : T)
      @coordinates = coordinates.map { |coordinate| coordinate.coordinates }.to_a
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

  # A `MultiPoint` is a `Geometry` representing several `Point`s.
  #
  # This class corresponds to the [GeoJSON MultiPoint](https://tools.ietf.org/html/rfc7946#section-3.1.3).
  class MultiPoint < Geometry
    include MultiGeometry(Point, Position)

    # Gets this MultiPoint's GeoJSON type ("MultiPoint")
    getter type : String = "MultiPoint"
  end

  # A `MultiLineString` is a `Geometry` representing several `LineString`s.
  #
  # This class corresponds to the [GeoJSON MultiLineString](https://tools.ietf.org/html/rfc7946#section-3.1.5).
  class MultiLineString < Geometry
    include MultiGeometry(LineString, LineStringCoordinates)

    # Gets this MultiLineString's GeoJSON type ("MultiLineString")
    getter type : String = "MultiLineString"
  end

  # A `MultiPolygon` is a `Geometry` representing several `Polygon`s.
  #
  # This class corresponds to the [GeoJSON MultiPolygon](https://tools.ietf.org/html/rfc7946#section-3.1.7).
  class MultiPolygon < Geometry
    include MultiGeometry(Polygon, PolyRings)

    # Gets this MultiPolygon's GeoJSON type ("MultiPolygon")
    getter type : String = "MultiPolygon"
  end
end
