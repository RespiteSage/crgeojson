require "json"

require "./base"
require "./feature"

module GeoJSON
  # A `FeatureCollection` represents a [GeoJSON FeatureCollection object](https://tools.ietf.org/html/rfc7946#section-3.3)
  # and contains one or more `Feature`s.
  class FeatureCollection < Base
    include JSON::Serializable

    # Gets this FeatureCollection's GeoJSON type ("FeatureCollection")
    getter type : String = "FeatureCollection"
    # Returns this `FeatureCollections` array of features.
    getter features : Array(Feature)

    # Creates a new `FeatureCollection` with the given *features*.
    def initialize(@features : Array(Feature))
    end

    def_equals_and_hash type, features
  end
end
