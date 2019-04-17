require "./geometry"
require "../coordinates/linear_ring"
require "../coordinates/poly_rings"

module GeoJSON
  # A `Polygon` is a `Geometry` representing a closed geometric figure in
  # geographic space with optional holes within it.
  #
  # This class corresponds to the [GeoJSON Polygon](https://tools.ietf.org/html/rfc7946#section-3.1.6).
  class Polygon < Geometry
    # Gets this Polygon's GeoJSON type ("Polygon")
    getter type : String = "Polygon"

    coordinate_type Coordinates::PolyRings, subtype: LinearRing

    # Create a new `Polygon` with an outer ring defined by the given *points* and
    # no holes.
    def initialize(points : Array(Position))
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

      @coordinates = PolyRings.new ring
    end

    # Creates a new `Polygon` with an outer ring defined by the given *points* and
    # no holes.
    def initialize(*points : Position)
      initialize points.to_a
    end

    # Creates a new `Polygon` with an outer ring created from the given *points*
    # and no holes.
    def initialize(*points : Array(Number))
      initialize *points.map { |point| Position.new point }
    end

    # Returns the exterior `LinearRing` of this `Polygon`
    def exterior
      coordinates[0]
    end
  end
end
