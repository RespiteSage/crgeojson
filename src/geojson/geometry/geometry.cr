require "json"

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
      def initialize(coordinates : Array)
        @coordinates = {{type}}.new coordinates
      end

      # Create a new geometry from the given *coordinates* CoordinateTree.
      def initialize(coordinates : CoordinateTree)
        @coordinates = {{type}}.new coordinates
      end
    end
  end
end
