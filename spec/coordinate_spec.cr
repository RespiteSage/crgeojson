require "./spec_helper"

describe Position do
  describe ".new" do
    it "properly sets the longitude and latitude" do
      result = Position.new 15.0, 10.0

      result.lon.should eq 15.0
      result.lat.should eq 10.0
    end

    it "accepts integers" do
      result = Position.new 15, 10

      result.lon.should eq 15.0
      result.lat.should eq 10.0
    end
  end

  describe "#from_json" do
    it "returns a Position corresponding to the json" do
      position = Position.from_json "[10.0,15.0]"
      reference = Position.new 10.0, 15.0

      position.should eq reference
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      position = Position.new 10.0, 15.0

      position.to_json.should eq "[10.0,15.0]"
    end
  end
end

describe LineStringCoordinates do
  describe ".new" do
    it "properly sets internal points from Positions" do
      first = Position.new 1.0, 2.0
      second = Position.new 3.0, 2.0

      result = LineStringCoordinates.new first, second

      result[0].should eq Position.new 1.0, 2.0
      result[1].should eq Position.new 3.0, 2.0
    end

    it "raises for fewer than two arguments" do
      point = Position.new 10.0, 15.0

      expect_raises(Exception, "LineString must have two or more points!") do
        linestring = LineStringCoordinates.new point
      end
    end

    it "works properly with an array of Positions" do
      first = Position.new 1.0, 2.0
      second = Position.new 3.0, 2.0

      result = LineStringCoordinates.new [first, second]

      result[0].should eq Position.new 1.0, 2.0
      result[1].should eq Position.new 3.0, 2.0
    end
  end

  describe "#from_json" do
    it "returns a LineString corresponding to the json" do
      first = Position.new 1.0, 2.0
      second = Position.new 3.0, 2.0

      linestring = LineStringCoordinates.from_json "[[1.0,2.0],[3.0,2.0]]"
      reference = LineStringCoordinates.new first, second

      linestring.should eq reference
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Position.new 1.0, 2.0
      second = Position.new 3.0, 2.0

      linestring = LineStringCoordinates.new first, second

      linestring.to_json.should eq "[[1.0,2.0],[3.0,2.0]]"
    end
  end
end

describe LinearRing do
  describe ".new" do
    it "properly sets internal points from Positions" do
      first = Position.new  1, 2
      second = Position.new 3, 2
      third = Position.new  2, 0
      fourth = Position.new 1, 2

      result = LinearRing.new first, second, third, fourth

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
      result[2].should eq Position.new 2, 0
      result[3].should eq Position.new 1, 2
    end

    it "raises for fewer than four arguments" do
      first = Position.new 1, 2
      second = Position.new 3, 2
      third = Position.new 1, 2

      expect_raises(Exception, "LinearRing must have four or more points!") do
        LinearRing.new first, second, third
      end
    end

    it "raises if the first and last argument differ" do
      first = Position.new  1, 2
      second = Position.new 3, 2
      third = Position.new  2, 0
      fourth = Position.new 5, 5

      expect_raises(Exception, "LinearRing must have matching first and last points!") do
        LinearRing.new first, second, third, fourth
      end
    end

    it "works properly with an array of Positions" do
      first = Position.new  1, 2
      second = Position.new 3, 2
      third = Position.new  2, 0
      fourth = Position.new 1, 2

      result = LinearRing.new [first, second, third, fourth]

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
      result[2].should eq Position.new 2, 0
      result[3].should eq Position.new 1, 2
    end
  end

  describe "#from_json" do
    it "returns a LinearRing corresponding to the json" do
      first = Position.new  0, 0
      second = Position.new 1, 0
      third = Position.new  0, 1
      fourth = Position.new 0, 0

      polygon = LinearRing.from_json "[[0.0,0.0],[1.0,0.0],[0.0,1.0],[0.0,0.0]]"
      reference = LinearRing.new first, second, third, fourth

      polygon.should eq reference
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Position.new  0, 0
      second = Position.new 1, 0
      third = Position.new  0, 1
      fourth = Position.new 0, 0

      linestring = LinearRing.new first, second, third, fourth

      linestring.to_json.should eq "[[0.0,0.0],[1.0,0.0],[0.0,1.0],[0.0,0.0]]"
    end
  end
end
