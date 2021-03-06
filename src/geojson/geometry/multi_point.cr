require "./geometry"
require "./multi_geometry"
require "./point"
require "../coordinates/position"

module GeoJSON
  # A `MultiPoint` is a `Geometry` representing several `Point`s.
  #
  # This class corresponds to the [GeoJSON MultiPoint](https://tools.ietf.org/html/rfc7946#section-3.1.3).
  class MultiPoint < Geometry
    include MultiGeometry(Point, Coordinates::Position)

    # Gets this MultiPoint's GeoJSON type ("MultiPoint")
    getter type : String = "MultiPoint"
  end
end
