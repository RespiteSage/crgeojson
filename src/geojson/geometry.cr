require "json"

module GeoJSON

  abstract class Geometry < Base

    abstract def coordinates

    def self.new(pull : JSON::PullParser)
      Geometry.from_json(pull.read_raw)
    end

    def Geometry.from_json(geometry_json)
      parsed = JSON.parse geometry_json
      type_string = parsed["type"]?

      if type_string.nil?
        raise "Type field missing!"
      end

      type_string = type_string.as_s?

      if type_string.nil?
        raise "Type field is not a string!"
      end

      geometry_types = [Point, MultiPoint, LineString, MultiLineString, Polygon, MultiPolygon]

      klass = geometry_types.find { |k| k.name == "GeoJSON::#{type_string}" }

      if klass.nil?
        raise %(Invalid geometry type "#{type_string}"!)
      else
        klass.from_json geometry_json
      end
    end

    def ==(other : self)
      coordinates == other.coordinates
    end

    def [](index : Int)
      coordinates[index]
    end

    macro inherited
      include JSON::Serializable

      def self.from_json(json)
        # yes, this is copied from Object; I'm not sure how else to do it
        parser = JSON::PullParser.new json
        new parser
      end
    end
  end

  class Point < Geometry
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

  class GeometryCollection < Base
    include JSON::Serializable

    getter type : String = "GeometryCollection"
    getter geometries : Array(Geometry)

    def initialize(*geometries : Geometry)
      @geometries = Array(Geometry).new.push(*geometries)
    end

    def [](index : Int)
      geometries[index]
    end

    def ==(other : self)
      geometries = other.geometries
    end
  end

end
