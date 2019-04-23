require "../spec_helper"

describe Point do
  describe ".new" do
    it "creates a new point with the given coordinates" do
      point = Point.new [10.0, 15.0]

      point.longitude.should eq 10.0
      point.latitude.should eq 15.0
    end

    it "takes integer arguments" do
      point = Point.new [10, 15]
    end

    it "creates a point with coordinates and altivation" do
      point = Point.new [12.0, 41.0, 300.0]

      point.longitude.should eq 12.0
      point.latitude.should eq 41.0
      point.altivation.should eq 300.0
    end

    it "creates a point from an array" do
      point = Point.new [12.0, 41.0, 300.0]

      point.longitude.should eq 12.0
      point.latitude.should eq 41.0
      point.altivation.should eq 300.0
    end
  end

  describe "#type" do
    it %(returns "Point") do
      point = Point.new [0, 0]

      point.type.should eq "Point"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      coordinates = Position.new [10, 15]
      point = Point.new coordinates

      reference_json = %({"type":"Point","coordinates":#{coordinates.to_json}})

      point.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#from_json" do
    it "creates a Point matching the json" do
      coordinates = Position.new [10, 15]

      result = Point.from_json %({"type":"Point","coordinates":#{coordinates.to_json}})

      reference = Point.new coordinates

      result.should eq reference
    end
  end

  describe "#==" do
    it "is true for the same object" do
      result = Point.new [0, 1]

      result.should eq result
    end

    it "is true for a different Point with the same coordinates" do
      first = Point.new [0, 1]

      second = Point.new [0, 1]

      first.should eq second
    end

    it "is false for a different Point with different coordinates" do
      first = Point.new [0, 1]

      second = Point.new [1, 0]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = Point.new [0, 1]

      second = "Something else"

      first.should_not eq second
    end
  end
end
