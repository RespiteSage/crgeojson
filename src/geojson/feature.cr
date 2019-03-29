module GeoJSON
  # A `Feature` represents a [GeoJSON Feature object](https://tools.ietf.org/html/rfc7946#section-3.2)
  # with a geometry and properties.
  class Feature < Base
    include JSON::Serializable

    getter type : String = "Feature"

    # Gets this Feature's geometry.
    @[JSON::Field(emit_null: true)]
    getter geometry : Geometry?

    # Gets this Feature's properties.
    @[JSON::Field(emit_null: true)]
    getter properties : Hash(String, JSON::Any::Type)?

    # Gets this Feature's id.
    getter id : (String | Int32 | Nil)

    # Creates a new `Feature` with the given *geometry*, *properties*, and *id*.
    def initialize(@geometry, @properties = nil, *, @id = nil)
    end

    def_equals_and_hash type, geometry, id, properties
  end
end
