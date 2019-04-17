require "./malformed_coordinate_exception"
require "./coordinates"

module GeoJSON
  # A `PolyRings` represents a collection of `LinearRing` coordinates. There are
  # no validity restrictions on how many `LinearRing` coordinates may be in a
  # `PolyRings`.
  class PolyRings < Coordinates(LinearRing)
    # Creates new `PolyRings` from the given *arrays*.
    def initialize(arrays : Array(Array))
      initialize arrays.map { |array| LinearRing.new array }
    end

    # Creates a new `PolyRings` from the given *arrays*.
    def initialize(*arrays : Array)
      initialize arrays.to_a
    end

    # Never raises.
    def raise_if_invalid
    end
  end
end
