require "./malformed_coordinate_exception"
require "./coordinates"
require "./line_string_coordinates"

module GeoJSON
  # A `LinearRing` is a closed set of `LineStringCoordinates`. To satisfy this
  # requirement, it must consist of at least four postions, and the first and
  # last positions must be the same.
  class LinearRing < LineStringCoordinates
    # Raises a `MalformedCoordinateException` if this `LinearRing` has fewer than
    # four coordinates or if its first and last positions are not equal.
    private def raise_if_invalid
      if coordinates.size < 4
        raise MalformedCoordinateException.new("LinearRing must have four or more points!")
      end

      if coordinates.first != coordinates.last
        raise MalformedCoordinateException.new("LinearRing must have matching first and last points!")
      end
    end
  end
end
