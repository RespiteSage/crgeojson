require "../spec_helper"

describe LineString do
  describe ".new" do
    it "creates a new linestring with the given array of points" do
      first = Position.new [10, 15]
      second = Position.new [20, 25]

      linestring = LineString.new [first, second]

      linestring[0].should eq Position.new([10.0, 15.0])
      linestring[1].should eq Position.new([20.0, 25.0])
    end

    it "rejects fewer than two points" do
      point = Position.new [10, 15]

      expect_raises(Exception, "LineString must have two or more points!") do
        linestring = LineString.new [point]
      end
    end

    it "creates a linestring from an array of coordinate arrays" do
      linestring = LineString.new [[10.0, 15.0], [20.0, 25.0]]

      linestring[0].should eq Position.new([10.0, 15.0])
      linestring[1].should eq Position.new([20.0, 25.0])
    end
  end

  describe "#type" do
    it %(returns "LineString") do
      linestring = LineString.new [Position.new([0, 0]), Position.new([1, 0])]

      linestring.type.should eq "LineString"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      coordinates = LineStringCoordinates.new [Position.new([10.0, 15.0]), Position.new([20.0, 25.0])]

      linestring = LineString.new coordinates

      reference_json = %({"type":"LineString","coordinates":#{coordinates.to_json}})

      linestring.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#from_json" do
    it "creates a LineString matching the json" do
      coordinates = LineStringCoordinates.new [Position.new([10.0, 15.0]), Position.new([20.0, 25.0])]

      result = LineString.from_json %({"type":"LineString","coordinates":#{coordinates.to_json}})

      reference = LineString.new coordinates

      result.should eq reference
    end
  end

  describe "#==" do
    it "is true for the same object" do
      result = LineString.new [Position.new([10.0, 15.0]), Position.new([20.0, 25.0])]

      result.should eq result
    end

    it "is true for a different LineString with the same coordinates" do
      first = LineString.new [Position.new([10.0, 15.0]), Position.new([20.0, 25.0])]

      second = LineString.new [Position.new([10.0, 15.0]), Position.new([20.0, 25.0])]

      first.should eq second
    end

    it "is false for a different LineString with different coordinates" do
      first = LineString.new [Position.new([10.0, 15.0]), Position.new([20.0, 25.0])]

      second = LineString.new [Position.new([10.0, 15.0]), Position.new([10.0, 13.0])]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = LineString.new [Position.new([10.0, 15.0]), Position.new([20.0, 25.0])]

      second = "Something else"

      first.should_not eq second
    end
  end
end
