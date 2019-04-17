require "../spec_helper"

describe LineStringCoordinates do
  describe ".new" do
    it "properly sets internal points from Positions" do
      first = Position.new 1, 2
      second = Position.new 3, 2

      result = LineStringCoordinates.new first, second

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
    end

    it "raises for fewer than two arguments" do
      point = Position.new 10.0, 15.0

      expect_raises(Exception, "LineString must have two or more points!") do
        linestring = LineStringCoordinates.new point
      end
    end

    it "works properly with an array of Positions" do
      first = Position.new 1, 2
      second = Position.new 3, 2

      result = LineStringCoordinates.new [first, second]

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
    end

    it "works properly with an array of arrays of floats" do
      result = LineStringCoordinates.new [[1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]]

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
      result[2].should eq Position.new 2, 0
      result[3].should eq Position.new 1, 2
    end

    it "works properly with multiple arrays of floats" do
      result = LineStringCoordinates.new [1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
      result[2].should eq Position.new 2, 0
      result[3].should eq Position.new 1, 2
    end

    it "creates appropriate coordinates from a CoordinateTree" do
      root = Root.new
      first_position = Branch.new root
      first_position_lon = Leaf.new first_position, 2
      first_position_lat = Leaf.new first_position, 3
      second_position = Branch.new root
      second_position_lon = Leaf.new second_position, 5
      second_position_lat = Leaf.new second_position, 7

      result = LineStringCoordinates.new root

      result.should eq LineStringCoordinates.new [[2, 3], [5, 7]]
    end
  end

  describe "#from_json" do
    it "returns a LineString corresponding to the json" do
      first = Position.new 1.0, 2.0
      second = Position.new 3.0, 2.0

      linestring = LineStringCoordinates.from_json "[#{first.to_json},#{second.to_json}]"
      reference = LineStringCoordinates.new first, second

      linestring.should eq reference
    end

    it "raises for fewer than two points" do
      expect_raises(MalformedCoordinateException, "LineString must have two or more points!") do
        LineStringCoordinates.from_json "[[1.0,2.0]]"
      end
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Position.new 1.0, 2.0
      second = Position.new 3.0, 2.0

      linestring = LineStringCoordinates.new first, second

      reference_json = "[#{first.to_json},#{second.to_json}]"

      linestring.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#==" do
    it "is true for the same object" do
      result = LineStringCoordinates.new Position.new(1, 2), Position.new(3, 2)

      result.should eq result
    end

    it "is true for a different LineStringCoordinates with the same coordinates" do
      first = LineStringCoordinates.new Position.new(1, 2), Position.new(3, 2)

      second = LineStringCoordinates.new Position.new(1, 2), Position.new(3, 2)

      first.should eq second
    end

    it "is false for a different LineStringCoordinates with different coordinates" do
      first = LineStringCoordinates.new Position.new(1, 2), Position.new(3, 2)

      second = LineStringCoordinates.new Position.new(1, 2), Position.new(1, 7)

      first.should_not eq second
    end

    it "is true for a LinearRing with the same coordinates" do
      first = LineStringCoordinates.new(
        Position.new(0, 0),
        Position.new(1, 0),
        Position.new(0, 1),
        Position.new(0, 0)
      )

      second = LinearRing.new(
        Position.new(0, 0),
        Position.new(1, 0),
        Position.new(0, 1),
        Position.new(0, 0)
      )

      first.should eq second
    end

    it "is false for an object of another Coordinates subclass" do
      first = LineStringCoordinates.new Position.new(1, 2), Position.new(3, 2)

      second = MockCoordinates(Position).new [Position.new(1, 2), Position.new(3, 2)]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = LineStringCoordinates.new Position.new(1, 2), Position.new(3, 2)

      second = "Something else"

      first.should_not eq second
    end
  end
end
