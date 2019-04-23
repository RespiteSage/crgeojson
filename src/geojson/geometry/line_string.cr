require "./geometry"
require "../coordinates/position"
require "../coordinates/line_string_coordinates"

module GeoJSON
  # A `LineString` is a `Geometry` representing two or more points in geographic
  # space connected consecutively by lines.
  #
  # This class corresponds to the [GeoJSON LineString](https://tools.ietf.org/html/rfc7946#section-3.1.4).
  class LineString < Geometry
    # Gets this LineString's GeoJSON type ("LineString")
    getter type : String = "LineString"

    coordinate_type Coordinates::LineStringCoordinates, subtype: Position
  end
end
