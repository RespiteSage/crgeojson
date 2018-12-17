
module GeoJSON

  class FeatureCollection < Base
    include JSON::Serializable

    getter type = "FeatureCollection"
    getter features : Array(Feature)

    def initialize(@features)
    end

    def_equals type, features
  end

end
