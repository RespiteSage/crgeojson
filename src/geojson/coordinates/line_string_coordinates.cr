require "./malformed_coordinate_exception"
require "./coordinates"
require "./position"

module GeoJSON::Coordinates
  # `LineStringCoordinates` represent multiple positions connected by lines.
  # They must contain at least two `Position` coordinates.
  class LineStringCoordinates < Coordinates(Position)
    # Creates new `LineStringCoordinates` from the given *arrays*.
    def initialize(arrays : Array(Array))
      initialize arrays.map { |array| Position.new(array) }
    end

    # Creates a new `LineStringCoordinates` from the given *arrays*.
    def initialize(*arrays : Array)
      initialize arrays.to_a
    end

    # Raises a `MalformedCoordinateException` if these `LineStringCoordinates`
    # have fewer than two positions.
    private def raise_if_invalid
      if coordinates.size < 2
        raise MalformedCoordinateException.new("LineString must have two or more points!")
      end
    end

    # Returns true if the *other* `LineStringCoordinates` have the same
    # coordinates as these `LineStringCoordinates`.
    def ==(other : LineStringCoordinates)
      self.coordinates == other.coordinates
    end
  end
end
