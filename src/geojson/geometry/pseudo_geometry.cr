require "../base"

module GeoJSON
  # TODO
  abstract class PseudoGeometry < Base
    # TODO
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

    # Parses the geometry type and coordinates (returned as a tuple, in that
    # order) from the given *parser*.
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

    # Creates a geometry of the given *geometry_type* with the given
    # *coordinates*.
    private def self.create_pseudo_geometry(of_type element_type, with contents)
      case element_type
      when "Point"
        Point.new contents.as CoordinateTree
      when "MultiPoint"
        MultiPoint.new contents.as CoordinateTree
      when "LineString"
        LineString.new contents.as CoordinateTree
      when "MultiLineString"
        MultiLineString.new contents.as CoordinateTree
      when "Polygon"
        Polygon.new contents.as CoordinateTree
      when "MultiPolygon"
        MultiPolygon.new contents.as CoordinateTree
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
