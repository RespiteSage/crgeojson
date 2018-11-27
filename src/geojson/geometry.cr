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

    abstract def coordinates

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

    def ==(other : self)
      coordinates == other.coordinates
    end

    def [](index : Int)
      coordinates[index]
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

    def initialize(coordinates : Position)
      @coordinates = coordinates
    end

    delegate lon, lat, to: coordinates
  end

  class LineString < Geometry
    include JSON::Serializable

    getter type : String = "LineString"
    getter coordinates : LineStringCoordinates

    def initialize(*points : Position)
      @coordinates = LineStringCoordinates.new *points
    end

    def initialize(coordinates : LineStringCoordinates)
      @coordinates = coordinates
    end
  end

  class Polygon < Geometry
    include JSON::Serializable

    getter type : String = "Polygon"
    getter coordinates : PolyRings

    def initialize(*points : Position)
      begin
        if points.first == points.last
          ring = LinearRing.new *points
        else
          ring = LinearRing.new points.to_a.push(points.first)
        end
      rescue ex_mal : MalformedCoordinateException
        if ex_mal.message == "LinearRing must have four or more points!"
          raise MalformedCoordinateException.new("Polygon must have three or more points!")
        else
          raise ex_mal
        end
      rescue ex
        raise ex
      end

      @coordinates = PolyRings.new ring
    end

    def initialize(*rings : LinearRing)
      @coordinates = PolyRings.new *rings
    end

    def initialize(coordinates : PolyRings)
      @coordinates = coordinates
    end

    def exterior
      coordinates[0]
    end
  end

end
