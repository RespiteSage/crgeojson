require "json"

module GeoJSON
  # TODO
  module MultiGeometry(T, E)
    # TODO
    getter coordinates : Array(E)

    # TODO
    def initialize(*coordinates : T)
      @coordinates = coordinates.map { |coordinate| coordinate.coordinates }.to_a
    end

    # TODO
    def initialize(coordinate_tree : CoordinateTree)
      @coordinates = coordinate_tree.children.map { |child| E.new child }
    end

    # TODO
    def [](index : Int)
      T.new coordinates[index]
    end
  end

  # TODO
  class MultiPoint < Geometry
    include MultiGeometry(Point, Position)

    getter type : String = "MultiPoint"
  end

  # TODO
  class MultiLineString < Geometry
    include MultiGeometry(LineString, LineStringCoordinates)

    getter type : String = "MultiLineString"
  end

  # TODO
  class MultiPolygon < Geometry
    include MultiGeometry(Polygon, PolyRings)

    getter type : String = "MultiPolygon"
  end
end
