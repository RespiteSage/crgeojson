require "./geometry"
require "./multi_geometry"
require "./polygon"
require "../coordinates/poly_rings"

module GeoJSON
  # A `MultiPolygon` is a `Geometry` representing several `Polygon`s.
  #
  # This class corresponds to the [GeoJSON MultiPolygon](https://tools.ietf.org/html/rfc7946#section-3.1.7).
  class MultiPolygon < Geometry
    include MultiGeometry(Polygon, Coordinates::PolyRings)

    # Gets this MultiPolygon's GeoJSON type ("MultiPolygon")
    getter type : String = "MultiPolygon"
  end
end
