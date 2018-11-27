require "json"

module GeoJSON

  enum GeometryTypes
    Point
    MultiPoint
    LineString
    MultiLineString
    Polygon
    MultiPolygon
    GeometryCollection

    def self.from_s(type_string : String)
      GeometryTypes.values.find { |type|
        type.to_s == type_string
      }
    end
  end

  abstract class Geometry < Base

    def self.from_json(json)
      parsed = JSON.parse json
      type_string = parsed["type"]?
      type_string = type_string.as_s? unless type_string.nil?

      if type_string
        case GeometryTypes.from_s type_string
        when .nil?
          raise "Invalid geometry type!"
        when .point?
          Point.from_json json
        end
      else
        raise "Type field invalid or missing!"
      end
    end

    macro inherited
      def self.from_json(json)
        # yes, this is copied from Object; I'm not sure how else to do it
        parser = JSON::PullParser.new json
        new parser
      end
    end
  end

  class Point < Geometry
    include JSON::Serializable

    getter type : String = "Point"
    getter coordinates : Position

    def initialize(lon, lat)
      @coordinates = Position.new lon.to_f64, lat.to_f64
    end

    delegate lon, lat, to: coordinates

    def ==(other : Point)
      coordinates == other.coordinates
    end
  end

  class MultiPoint < Geometry
    include JSON::Serializable

    getter type : String = "MultiPoint"
    getter coordinates : Array(Position)

    def initialize(*points : Position)
      @coordinates = points.to_a
    end

    def [](index : Int32 | Int64)
      coordinates[index]
    end

    def ==(other : MultiPoint)
      coordinates == other.coordinates
    end
  end

end
