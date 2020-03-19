require "./geometry"
require "./multi_geometry"
require "./line_string"
require "../coordinates/line_string_coordinates"

module GeoJSON
  # A `MultiLineString` is a `Geometry` representing several `LineString`s.
  #
  # This class corresponds to the [GeoJSON MultiLineString](https://tools.ietf.org/html/rfc7946#section-3.1.5).
  class MultiLineString < Geometry
    include MultiGeometry(LineString, Coordinates::LineStringCoordinates)

    # Gets this MultiLineString's GeoJSON type ("MultiLineString")
    getter type : String = "MultiLineString"
  end
end
