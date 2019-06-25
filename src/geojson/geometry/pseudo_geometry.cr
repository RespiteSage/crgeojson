require "../base"

module GeoJSON
  # A `PseudoGeometry` is a geometry element in a GeoJSON feature.
  #
  # This class is really just a union of `Geometry` and `GeometryCollection`
  # with built-in JSON parsing logic.
  abstract class PseudoGeometry < Base
    # Creates a new `PseudoGeometry` from the given *parser*.
    #
    # This static class method automatically chooses the correct
    # PseudoGeometry class (`Geometry` or `GeometryCollection`) to create.
    def PseudoGeometry.new(parser : JSON::PullParser)
      element_type, contents = parse_pseudo_geometry using: parser

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
      while parser.kind != :end_object
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

    # Creates a `Geometry` or `GeometryCollection` from the given GeoJSON string.
    def PseudoGeometry.from_json(geometry_json)
      PseudoGeometry.new(JSON::PullParser.new geometry_json)
    end
  end
end
