require "json"

require "./geometry"
require "./geometry_collection"
require "../coordinates/coordinate_tree"

module GeoJSON
  # A `PseudoGeometryConverter` handles deserialization and serialization of
  # geometry elements in GeoJSON features.
  struct PseudoGeometryConverter
    # Creates a `Geometry` or `GeometryCollection` from the given GeoJSON string.
    def self.from_json(parser : JSON::PullParser)
      element_type, contents = self.parse_pseudo_geometry using: parser

      if element_type.nil?
        raise "Type field missing!"
      end

      if contents.nil?
        raise "Coordinates missing!"
      end

      create_pseudo_geometry of_type: element_type, with: contents
    end

    # Parses the type and coordinates (returned as a tuple, in that order) from
    # the given *parser*.
    private def self.parse_pseudo_geometry(using parser : JSON::PullParser)
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
        when "geometries"
          contents = Array(Geometry).new parser
        else
          parser.read_next # we currently ignore extra elements
        end
      end
      parser.read_end_object

      {element_type, contents}
    end

    # Creates a `Geometry` or `GeometryCollection` based on the given
    #  *element_type* and *contents*.
    private def self.create_pseudo_geometry(of_type element_type, with contents)
      case element_type
      when "Point", "MultiPoint", "LineString", "MultiLineString", "Polygon", "MultiPolygon"
        Geometry.create_geometry element_type, contents.as CoordinateTree
      when "GeometryCollection"
        GeometryCollection.new contents.as Array(Geometry)
      else
        raise %(Invalid geometry element type "#{element_type}"!)
      end
    end

    # Serializes a `Geometry` or `GeometryCollection` by passing the *builder*
    # to its `#to_json` method.
    def self.to_json(value, builder : JSON::Builder)
      value.to_json builder
    end
  end
end
