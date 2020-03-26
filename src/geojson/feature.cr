require "json"

require "./base"
require "./geometry/geometry"
require "./geometry/geometry_collection"
require "./geometry/pseudo_geometry_converter"

module GeoJSON
  alias PseudoGeometry = Geometry | GeometryCollection

  # A `Feature` represents a [GeoJSON Feature object](https://tools.ietf.org/html/rfc7946#section-3.2)
  # with a geometry and properties.
  class Feature < Base
    include JSON::Serializable

    # Gets this Feature's GeoJSON type ("Feature")
    getter type : String = "Feature"

    @[JSON::Field(emit_null: true, converter: GeoJSON::PseudoGeometryConverter)]
    # Gets this Feature's geometry.
    getter geometry : PseudoGeometry?

    @[JSON::Field(emit_null: true)]
    # Gets this Feature's properties.
    getter properties : Hash(String, JSON::Any::Type)?

    # Gets this Feature's id.
    getter id : (String | Int32 | Nil)

    # Creates a new `Feature` with the given *geometry*, *properties*, and *id*.
    def initialize(@geometry, @properties = nil, *, @id = nil)
    end

    def_equals_and_hash type, geometry, id, properties
  end
end
