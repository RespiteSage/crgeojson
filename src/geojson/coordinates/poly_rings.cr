require "./coordinates"
require "./linear_ring"

module GeoJSON::Coordinates
  # A `PolyRings` represents a collection of `LinearRing` coordinates. There are
  # no validity restrictions on how many `LinearRing` coordinates may be in a
  # `PolyRings`.
  class PolyRings < Coordinates(LinearRing)
    # Never raises.
    def raise_if_invalid
    end
  end
end
