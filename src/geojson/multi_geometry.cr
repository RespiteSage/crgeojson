require "json"

module GeoJSON
  class MultiPoint < Geometry
    getter type : String = "MultiPoint"
    getter coordinates : Array(Position)

    def initialize(*points : Point)
      @coordinates = points.map { |point| point.coordinates }.to_a
    end

    def [](index : Int)
      Point.new coordinates[index]
    end
  end

  class MultiLineString < Geometry
    getter type : String = "MultiLineString"
    getter coordinates : Array(LineStringCoordinates)

    def initialize(*linestrings : LineString)
      @coordinates = linestrings.map { |linestring| linestring.coordinates }.to_a
    end

    def [](index : Int)
      LineString.new coordinates[index]
    end
  end

  class MultiPolygon < Geometry
    getter type : String = "MultiPolygon"
    getter coordinates : Array(PolyRings)

    def initialize(*polygons : Polygon)
      @coordinates = polygons.map { |polygon| polygon.coordinates }.to_a
    end

    def [](index : Int)
      Polygon.new coordinates[index]
    end
  end
end
