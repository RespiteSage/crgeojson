require "json"

module GeoJSON
  # A `GeoJSON::Base` specifies the properties shared by all GeoJSON classes.
  private abstract class Base
    # Returns the type of this GeoJSON object.
    abstract def type : String
  end
end
