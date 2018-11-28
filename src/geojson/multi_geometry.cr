require "json"

module GeoJSON

  private abstract class MultiGeometry(T, U) < Geometry
    abstract def coordinates : Array(T)

    def [](index : Int)
      U.new coordinates[index]
    end

    macro inherited
      include JSON::Serializable
    end
  end

  class MultiPoint < MultiGeometry(Position, Point)
    getter type : String = "MultiPoint"
    getter coordinates : Array(Position)

    def initialize(*points : Position)
      @coordinates = points.to_a
    end
  end

  class MultiLineString < MultiGeometry(LineStringCoordinates, LineString)
    getter type : String = "MultiLineString"
    getter coordinates : Array(LineStringCoordinates)

    def initialize(*linestrings : LineString)
      @coordinates = linestrings.map { |linestring| linestring.coordinates}.to_a
    end
  end

  class MultiPolygon < MultiGeometry(PolyRings, Polygon)
    getter type : String = "MultiPolygon"
    getter coordinates : Array(PolyRings)

    def initialize(*polygons : Polygon)
      @coordinates = polygons.map { |polygon| polygon.coordinates}.to_a
    end
  end

end
