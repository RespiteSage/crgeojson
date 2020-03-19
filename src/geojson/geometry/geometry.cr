require "json"

require "../base"
require "../coordinates/coordinate_tree"

module GeoJSON
  include Coordinates

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
      while parser.kind != JSON::PullParser::Kind::EndObject
        case parser.read_string
        when "type"
          begin
            element_type = parser.read_string
          rescue JSON::ParseException
            raise "Type field is not a string!"
          end
        when "coordinates"
          contents = CoordinateTree.new parser
        else
          parser.read_next # we currently ignore extra elements
        end
      end
      parser.read_end_object

      if element_type == "GeometryCollection"
        raise "GeometryCollection is not a Geometry!"
      end

      {element_type, contents.as CoordinateTree}
    end

    # Creates a geometry of the given *geometry_type* with the given
    # *coordinates*.
    protected def self.create_geometry(of_type geometry_type, with coordinates)
      {% begin %}
        case geometry_type
        {% for klass in @type.subclasses.map(&.id.split("::").last) %}
          when "{{klass.id}}"
            {{klass.id}}.new coordinates
        {% end %}
        else
          raise %(Invalid geometry type "#{geometry_type}"!)
        end
      {% end %}
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
