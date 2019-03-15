module GeoJSON
  # TODO
  class Feature < Base
    include JSON::Serializable

    getter type : String = "Feature"

    # TODO
    @[JSON::Field(emit_null: true)]
    getter geometry : Geometry?

    # TODO
    @[JSON::Field(emit_null: true)]
    getter properties : Hash(String, JSON::Any::Type)?

    # TODO
    getter id : (String | Int32 | Nil)

    # TODO
    def initialize(@geometry, @properties = nil, *, @id = nil)
    end

    def_equals_and_hash type, geometry, id, properties
  end
end
