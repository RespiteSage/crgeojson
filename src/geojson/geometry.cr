require "json"
require "./coordinates/position"
require "./coordinates/line_string_coordinates"
require "./coordinates/linear_ring"
require "./coordinates/poly_rings"

module GeoJSON
  # A `Geometry` represents a figure in geographic space.
  abstract class Geometry < Base
    # Returns this Geometry's coordinates.
    abstract def coordinates

    # Creates a new `Geometry` from the given *parser*.
    #
    # This static class method automatically chooses the correct
    # Geometry class to create.
    def Geometry.new(parser : JSON::PullParser)
      geometry_type, coordinates = parse_geometry using: parser

      if geometry_type.nil?
        raise "Type field missing!"
      end

      if coordinates.nil?
        raise "Coordinates missing!"
      end

      create_geometry of_type: geometry_type, with: coordinates
    end

    # Parses the geometry type and coordinates (returned as a tuple, in that
    # order) from the given *parser*.
    private def self.parse_geometry(using parser : JSON::PullParser)
      parser.read_begin_object
      while parser.kind != :end_object
        case parser.read_string
        when "type"
          begin
            geometry_type = parser.read_string
          rescue JSON::ParseException
            raise "Type field is not a string!"
          end
        when "coordinates"
          coordinates = CoordinateTree.new parser
        else
          parser.read_next # we currently ignore extra elements
        end
      end
      parser.read_end_object

      {geometry_type, coordinates}
    end

    # Creates a geometry of the given *geometry_type* with the given
    # *coordinates*.
    private def self.create_geometry(of_type geometry_type, with coordinates)
      case geometry_type
      when "Point"
        Point.new coordinates
      when "MultiPoint"
        MultiPoint.new coordinates
      when "LineString"
        LineString.new coordinates
      when "MultiLineString"
        MultiLineString.new coordinates
      when "Polygon"
        Polygon.new coordinates
      when "MultiPolygon"
        MultiPolygon.new coordinates
      else
        raise %(Invalid geometry type "#{geometry_type}"!)
      end
    end

    # Creates a `Geometry` from the given GeoJSON string.
    def Geometry.from_json(geometry_json)
      Geometry.new(JSON::PullParser.new geometry_json)
    end

    def_equals_and_hash coordinates, type

    # Gets the coordinate at the given index.
    delegate "[]", to: coordinates

    # We need to inherit the Object-default self.from_json because we don't want
    # Geometry subclasses inheriting its special self.from_json method.
    macro inherited
      # Creates a new geometry from the given *parser*.
      include JSON::Serializable

      def self.from_json(json)
        # yes, this is copied from Object; I'm not sure how else to do it
        parser = JSON::PullParser.new json
        new parser
      end
    end

    # We use a macro to create subclass initializers because any subclass
    # initializer will obscure all superclass initializers.
    macro coordinate_type(type, subtype)
      getter coordinates : {{type}}

      # Create a new geometry with the given *coordinates*.
      def initialize(@coordinates : {{type}})
      end

      # Create a new geometry with coordinates created from the given
      # *coordinates* array.
      def initialize(coordinates : Array({{subtype}}))
        @coordinates = {{type}}.new coordinates
      end

      # Create a new geometry with coordinates creates from the given
      # *coordinates*.
      def initialize(*coordinates : {{subtype}})
        initialize coordinates.to_a
      end

      # Create a new geometry from the given *coordinates* CoordinateTree.
      def initialize(coordinates : CoordinateTree)
        @coordinates = {{type}}.new coordinates
      end
    end
  end

  # A `Point` is a `Geometry` representing a single `Position` in geographic
  # space.
  #
  # This class corresponds to the [GeoJSON Point](https://tools.ietf.org/html/rfc7946#section-3.1.2).
  class Point < Geometry
    # Gets this Point's GeoJSON type ("Point")
    getter type : String = "Point"

    coordinate_type Position, subtype: Number

    # Creates a new `Point` at the given longitude, latitude, and
    # altitude/elevation (altivation).
    def initialize(longitude lon, latitude lat, altivation alt = nil)
      @coordinates = Position.new lon, lat, alt
    end

    # Gets this Point's longitude in decimal degrees according to WGS84.
    delegate longitude, to: coordinates

    # Gets this Point's latitude in decimal degrees according to WGS84.
    delegate latitude, to: coordinates

    # Gets this Point's altitude/elevation.
    #
    # Technically, this positional value is meant to be the height in meters
    # above the WGS84 ellipsoid.
    delegate altivation, to: coordinates
  end

  # A `LineString` is a `Geometry` representing two or more points in geographic
  # space connected consecutively by lines.
  #
  # This class corresponds to the [GeoJSON LineString](https://tools.ietf.org/html/rfc7946#section-3.1.4).
  class LineString < Geometry
    # Gets this LineString's GeoJSON type ("LineString")
    getter type : String = "LineString"

    coordinate_type LineStringCoordinates, subtype: Position

    # Create a new `LineString` with coordinates based on the given *points*.
    def initialize(*points : Array(Number))
      @coordinates = LineStringCoordinates.new *points
    end
  end

  # A `Polygon` is a `Geometry` representing a closed geometric figure in
  # geographic space with optional holes within it.
  #
  # This class corresponds to the [GeoJSON Polygon](https://tools.ietf.org/html/rfc7946#section-3.1.6).
  class Polygon < Geometry
    # Gets this Polygon's GeoJSON type ("Polygon")
    getter type : String = "Polygon"

    coordinate_type PolyRings, subtype: LinearRing

    # Create a new `Polygon` with an outer ring defined by the given *points* and
    # no holes.
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

    # Creates a new `Polygon` with an outer ring defined by the given *points* and
    # no holes.
    def initialize(*points : Position)
      initialize points.to_a
    end

    # Creates a new `Polygon` with an outer ring created from the given *points*
    # and no holes.
    def initialize(*points : Array(Number))
      initialize *points.map { |point| Position.new point }
    end

    # Returns the exterior `LinearRing` of this `Polygon`
    def exterior
      coordinates[0]
    end
  end

  # A `GeometryCollection` represents a collection of several geometries
  # (`Geometry` objects).
  #
  # This class corresponds to the [GeoJSON GeometryCollection](https://tools.ietf.org/html/rfc7946#section-3.1.8).
  class GeometryCollection < Base
    include JSON::Serializable

    # Gets this GeometryCollection's GeoJSON type ("GeometryCollection")
    getter type : String = "GeometryCollection"
    # Returns an array of the geometries in this `GeometryCollection`
    getter geometries : Array(Geometry)

    # Creates a new `GeometryCollection` containing the given *geometries*.
    def initialize(*geometries : Geometry)
      @geometries = Array(Geometry).new.push(*geometries)
    end

    def_equals geometries

    # Gets the geometry at the given index.
    delegate "[]", to: geometries
  end
end
