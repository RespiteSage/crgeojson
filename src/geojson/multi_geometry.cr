require "json"

module GeoJSON
  module MultiGeometry(T, E)
    getter coordinates : Array(E)

    def initialize(*coordinates : T)
      @coordinates = coordinates.map { |coordinate| coordinate.coordinates }.to_a
    end

    def initialize(coordinate_tree : CoordinateTree)
      @coordinates = coordinate_tree.children.map { |child| E.new child }
    end

    def [](index : Int)
      T.new coordinates[index]
    end
  end

  class MultiPoint < Geometry
    include MultiGeometry(Point, Position)

    getter type : String = "MultiPoint"
  end

  class MultiLineString < Geometry
    include MultiGeometry(LineString, LineStringCoordinates)

    getter type : String = "MultiLineString"
  end

  class MultiPolygon < Geometry
    include MultiGeometry(Polygon, PolyRings)

    getter type : String = "MultiPolygon"
  end
end
