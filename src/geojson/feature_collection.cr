module GeoJSON
  class FeatureCollection < Base
    include JSON::Serializable

    getter type : String = "FeatureCollection"
    getter features : Array(Feature)

    def initialize(@features : Array(Feature))
    end

    def initialize(*features : Feature)
      @features = features.to_a
    end

    def_equals type, features
  end
end
