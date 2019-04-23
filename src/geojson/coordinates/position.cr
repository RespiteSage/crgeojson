require "./malformed_coordinate_exception"
require "./coordinates"

module GeoJSON::Coordinates
  # A `Position` represents a position on earth with a longitude, latitude, and
  # optional altitude/elevation (`#altivation`).
  #
  # According to the GeoJSON spec, longitude and latitude are to be stored as
  # decimal degrees, and altitude/elevation is to be stored as a height in
  # meters.
  class Position < Coordinates(Float64)
    # Creates a new `Position` with the given *longitude*, *latitude*, and
    # *altivation*.
    def initialize(*, longitude lon, latitude lat, altivation alt = nil)
      unless alt.nil?
        initialize [lon, lat, alt]
      else
        initialize [lon, lat]
      end
    end

    # Creates a new `Position` from the given *coordinate_tree*.
    def initialize(coordinate_tree : CoordinateTree)
      initialize coordinate_tree.map { |child| child.leaf_value }
    end

    # Returns the longitude of this `Position`.
    #
    # The first coordinate of this `Position` is assumed to be the longitude.
    def longitude
      coordinates[0]
    end

    # Returns the latitude of this `Position`.
    #
    # The second coordinate of this `Position` is assumed to be the latitude.
    def latitude
      coordinates[1]
    end

    # Returns the altivation (altitude or elevation) of this `Position`.
    #
    # The third coordinate of this `Position` is assumed to be the altivation.
    def altivation
      coordinates[2]?
    end

    # Raises a `MalformedCoordinateException` if this `Position` has fewer than
    # two or more than three coordinate values.
    private def raise_if_invalid
      if coordinates.size < 2 || coordinates.size > 3
        raise MalformedCoordinateException.new "Position must have two or three coordinates!"
      end
    end
  end
end
