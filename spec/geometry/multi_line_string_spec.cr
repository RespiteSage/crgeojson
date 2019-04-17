require "../spec_helper"

describe MultiLineString do
  describe ".new" do
    it "creates a new multilinestring with the given points" do
      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0

      linestring = LineString.new first, second

      multilinestring = MultiLineString.new linestring

      multilinestring[0].should eq LineString.new(Position.new(10.0, 15.0), Position.new(20.0, 25.0))
    end
  end

  describe "#type" do
    it %(returns "MultiLineString") do
      linestring = LineString.new Position.new(0, 0), Position.new(1, 0)

      multilinestring = MultiLineString.new linestring

      multilinestring.type.should eq "MultiLineString"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = LineStringCoordinates.new Position.new(0, 0), Position.new(0, 1)
      second = LineStringCoordinates.new Position.new(1, 0), Position.new(0, 1)

      multilinestring = MultiLineString.new LineString.new(first), LineString.new(second)

      reference_json = %({"type":"MultiLineString","coordinates":[#{first.to_json},#{second.to_json}]})

      multilinestring.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#from_json" do
    it "creates a MultiLineString matching the json" do
      first = LineStringCoordinates.new Position.new(0, 0), Position.new(0, 1)
      second = LineStringCoordinates.new Position.new(1, 0), Position.new(0, 1)

      result = MultiLineString.from_json %({"type":"MultiLineString","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiLineString.new LineString.new(first), LineString.new(second)

      result.should eq reference
    end
  end

  describe "#==" do
    first_linestring = LineString.new Position.new(1, 2), Position.new(3, 2)
    second_linestring = LineString.new Position.new(1, 2), Position.new(1, 7)

    it "is true for the same object" do
      result = MultiLineString.new first_linestring, second_linestring

      result.should eq result
    end

    it "is true for a different MultiLineString with the same coordinates" do
      first = MultiLineString.new first_linestring, second_linestring

      second = MultiLineString.new first_linestring, second_linestring

      first.should eq second
    end

    it "is false for a different MultiLineString with different coordinates" do
      first = MultiLineString.new first_linestring, second_linestring

      second = MultiLineString.new second_linestring

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = MultiLineString.new first_linestring, second_linestring

      second = "Something else"

      first.should_not eq second
    end
  end
end
