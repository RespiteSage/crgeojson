
module GeoJSON

  class Feature < Base
    include JSON::Serializable

    getter type = "Feature"

    @[JSON::Field(emit_null: true)]
    property geometry : Geometry?

    property id : (Int32 | String | Nil)

    @[JSON::Field(emit_null: true)]
    property properties : Hash(String,JSON::Any::Type)?

    def initialize(@geometry, @properties = nil, *, @id = nil)
    end

    def_equals type, geometry, id, properties

  end


end
