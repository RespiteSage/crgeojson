require "json"
require "./coordinate"

module GeoJSON

  abstract class Geometry < Base

    abstract def coordinates

    def self.new(pull : JSON::PullParser)
      Geometry.from_json(pull.read_raw)
    end

    def Geometry.from_json(geometry_json)
      parsed = JSON.parse geometry_json
      type_field = parsed["type"]?

      if type_field.nil?
        raise "Type field missing!"
      end

      type_string = type_field.as_s?

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

    def_equals coordinates

    delegate "[]", to: coordinates

    macro inherited
      include JSON::Serializable

      def self.from_json(json)
        # yes, this is copied from Object; I'm not sure how else to do it
        parser = JSON::PullParser.new json
        new parser
      end
    end

    macro coordinate_type(type, subtype=nil)
      getter coordinates : {{type}}

      def initialize(@coordinates : {{type}})
      end

      {% if subtype %}
      def initialize(coordinates : Array({{subtype}}))
        @coordinates = {{type}}.new coordinates
      end

      def initialize(*coordinates : {{subtype}})
        initialize coordinates.to_a
      end
      {% end %}
    end
  end

  class Point < Geometry
    getter type : String = "Point"

    coordinate_type Position, subtype: Number

    def initialize(longitude lon, latitude lat, altivation alt = nil)
      @coordinates = Position.new lon, lat, alt
    end

    delegate longitude, latitude, altivation, to: coordinates
  end

  class LineString < Geometry
    getter type : String = "LineString"

    coordinate_type LineStringCoordinates, subtype: Position

    def initialize(*points : Array(Number))
      @coordinates = LineStringCoordinates.new *points
    end
  end

  class Polygon < Geometry
    getter type : String = "Polygon"

    coordinate_type PolyRings, subtype: LinearRing

    def initialize(points : Array(Position))
      begin
        if points.first == points.last
          ring = LinearRing.new points
        else
          ring = LinearRing.new points.push(points.first)
        end
      rescue ex_mal : MalformedCoordinateException
        if ex_mal.message == "LinearRing must have four or more points!"
          raise MalformedCoordinateException.new("Polygon must have three or more points!")
        else
          raise ex_mal
        end
      end

      @coordinates = PolyRings.new ring
    end

    def initialize(*points : Position)
      initialize points.to_a
    end

    def initialize(*points : Array(Number))
      initialize *points.map { |point| Position.new point }
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

    def_equals geometries

    delegate "[]", to: geometries
  end

end
