require "./geometry"
require "./single_geometry"
require "../coordinates/poly_rings"
require "../coordinates/linear_ring"

module GeoJSON
  # A `Polygon` is a `Geometry` representing a closed geometric figure in
  # geographic space with optional holes within it.
  #
  # This class corresponds to the [GeoJSON Polygon](https://tools.ietf.org/html/rfc7946#section-3.1.6).
  class Polygon < Geometry
    include SingleGeometry(Coordinates::PolyRings)

    # Gets this Polygon's GeoJSON type ("Polygon")
    getter type : String = "Polygon"

    # Creates a new `Polygon` with the given *rings*.
    def self.new(rings : Array(LinearRing))
      new PolyRings.new rings
    end

    # Create a new `Polygon` with an outer ring defined by the given *points* and
    # no holes.
    def self.new(points : Array)
      begin
        if points.first == points.last
          ring = LinearRing.new points
        else
          ring = LinearRing.new points.push(points.first)
        end
      rescue ex_mal : MalformedCoordinateException
        if ex_mal.message == "LinearRing must have four or more points!"
          raise MalformedCoordinateException.new("Polygon must have three or more points!")
        else
          raise ex_mal
        end
      end

      new PolyRings.new [ring]
    end

    # Returns the exterior `LinearRing` of this `Polygon`
    def exterior
      coordinates[0]
    end
  end
end
