require "./geometry"
require "./single_geometry"
require "../coordinates/position"

module GeoJSON
  # A `Point` is a `Geometry` representing a single `Position` in geographic
  # space.
  #
  # This class corresponds to the [GeoJSON Point](https://tools.ietf.org/html/rfc7946#section-3.1.2).
  class Point < Geometry
    include SingleGeometry(Coordinates::Position)

    # Gets this Point's GeoJSON type ("Point")
    getter type : String = "Point"

    # Creates a new `Point` at the given longitude, latitude, and
    # altitude/elevation (altivation).
    def self.new(*, longitude lon, latitude lat, altivation alt = nil)
      new Position.new longitude: lon, latitude: lat, altivation: alt
    end

    # Gets this Point's longitude in decimal degrees according to WGS84.
    delegate longitude, to: coordinates

    # Gets this Point's latitude in decimal degrees according to WGS84.
    delegate latitude, to: coordinates

    # Gets this Point's altitude/elevation.
    #
    # Technically, this positional value is meant to be the height in meters
    # above the WGS84 ellipsoid.
    delegate altivation, to: coordinates
  end
end
