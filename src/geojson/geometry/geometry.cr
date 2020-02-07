require "json"
require "./pseudo_geometry"

module GeoJSON
  # A `Geometry` represents a figure in geographic space.
  abstract class Geometry < PseudoGeometry
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
      element_type, contents = parse_pseudo_geometry using: parser

      if element_type == "GeometryCollection"
        raise "GeometryCollection is not a Geometry!"
      end

      {element_type, contents.as CoordinateTree}
    end

    # Creates a geometry of the given *geometry_type* with the given
    # *coordinates*.
    protected def self.create_geometry(of_type geometry_type, with coordinates)
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