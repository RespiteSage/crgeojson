module GeoJSON
  # TODO
  class FeatureCollection < Base
    include JSON::Serializable

    # TODO
    getter type : String = "FeatureCollection"
    # TODO
    getter features : Array(Feature)

    # TODO
    def initialize(@features : Array(Feature))
    end

    # TODO
    def initialize(*features : Feature)
      @features = features.to_a
    end

    def_equals_and_hash type, features
  end
end
