require "json"

module GeoJSON
  private abstract class Base
    abstract def type : String
  end
end
