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

    def self.contains?(type : String)
      GeometryTypes.names.includes? type
    end
  end

  abstract class Geometry < Base

    def self.from_json(json)
      parsed = JSON.parse json
      type_string = parsed["type"]?
      type_string = type_string.as_s? unless type_string.nil?

      if type_string
        if GeometryTypes.contains? type_string
          # TODO
        else
          raise "Invalid geometry type!"
        end
      else
        raise "Type field invalid or missing!"
      end
    end

  end

  class Point < Geometry
    getter type = "Point"
    getter lon : Float32 | Float64
    getter lat : Float32 | Float64

    def initialize(lon, lat)
      @lon = lon.to_f64
      @lat = lat.to_f64
    end
  end

end
