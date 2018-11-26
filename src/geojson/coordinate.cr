require "json"

module GeoJSON

  class Position

    protected getter coordinates : Array(Float64)

    def initialize(longitude, latitude)
      @coordinates = [longitude.to_f64, latitude.to_f64]
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Float64).new(parser)
    end

    def lon
      coordinates[0]
    end

    def lat
      coordinates[1]
    end

    def ==(other : Position)
      coordinates == other.coordinates
    end

    def self.from_json(json)
      coordinates = Array(Float64).from_json json
      Position.new coordinates[0], coordinates[1]
    end

    delegate to_json, to: coordinates
  end

end
