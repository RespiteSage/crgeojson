require "./geometry"

module GeoJSON
  # A `GeometryCollection` represents a collection of several geometries
  # (`Geometry` objects).
  #
  # This class corresponds to the [GeoJSON GeometryCollection](https://tools.ietf.org/html/rfc7946#section-3.1.8).
  class GeometryCollection < Base
    include JSON::Serializable

    # Gets this GeometryCollection's GeoJSON type ("GeometryCollection")
    getter type : String = "GeometryCollection"
    # Returns an array of the geometries in this `GeometryCollection`
    getter geometries : Array(Geometry)

    # Creates a new `GeometryCollection` containing the given *geometries*.
    def initialize(*geometries : Geometry)
      @geometries = Array(Geometry).new.push(*geometries)
    end

    def_equals geometries

    # Gets the geometry at the given index.
    delegate "[]", to: geometries
  end
end
