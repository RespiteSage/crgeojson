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

    macro inherited
      # Creates a new geometry from the given *parser*.
      include JSON::Serializable
    end
  end
end
