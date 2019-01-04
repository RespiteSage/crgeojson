module GeoJSON
  class Feature < Base
    include JSON::Serializable

    getter type : String = "Feature"

    @[JSON::Field(emit_null: true)]
    getter geometry : Geometry?

    @[JSON::Field(emit_null: true)]
    getter properties : Hash(String, JSON::Any::Type)?

    getter id : (String | Int32 | Nil)

    def initialize(@geometry, @properties = nil, *, @id = nil)
    end

    def_equals_and_hash type, geometry, id, properties
  end
end
