require "../spec_helper"

describe LinearRing do
  describe ".new" do
    it "properly sets internal points from an array of Positions" do
      first = Position.new [1, 2]
      second = Position.new [3, 2]
      third = Position.new [2, 0]
      fourth = Position.new [1, 2]

      result = LinearRing.new [first, second, third, fourth]

      result[0].should eq Position.new [1, 2]
      result[1].should eq Position.new [3, 2]
      result[2].should eq Position.new [2, 0]
      result[3].should eq Position.new [1, 2]
    end

    it "raises for fewer than four arguments" do
      first = Position.new [1, 2]
      second = Position.new [3, 2]
      third = Position.new [1, 2]

      expect_raises(Exception, "LinearRing must have four or more points!") do
        LinearRing.new [first, second, third]
      end
    end

    it "raises if the first and last argument differ" do
      first = Position.new [1, 2]
      second = Position.new [3, 2]
      third = Position.new [2, 0]
      fourth = Position.new [5, 5]

      expect_raises(Exception, "LinearRing must have matching first and last points!") do
        LinearRing.new [first, second, third, fourth]
      end
    end

    it "creates new coordinates from an array of arrays of floats" do
      result = LinearRing.new [[1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]]

      result[0].should eq Position.new [1, 2]
      result[1].should eq Position.new [3, 2]
      result[2].should eq Position.new [2, 0]
      result[3].should eq Position.new [1, 2]
    end

    it "creates appropriate coordinates from a CoordinateTree" do
      root = Root.new
      first_position = Branch.new root
      first_position_lon = Leaf.new first_position, 2
      first_position_lat = Leaf.new first_position, 3
      second_position = Branch.new root
      second_position_lon = Leaf.new second_position, 5
      second_position_lat = Leaf.new second_position, 7
      third_position = Branch.new root
      third_position_lon = Leaf.new third_position, 11
      third_position_lat = Leaf.new third_position, 13
      fourth_position = Branch.new root
      fourth_position_lon = Leaf.new fourth_position, 2
      fourth_position_lat = Leaf.new fourth_position, 3

      result = LinearRing.new root

      result.should eq LinearRing.new [[2, 3], [5, 7], [11, 13], [2, 3]]
    end

    it "creates a new LinearRing by copying an existing LinearRing" do
      old_coordinates = LinearRing.new [[1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]]

      new_coordinates = LinearRing.new old_coordinates

      new_coordinates.coordinates.should eq old_coordinates.coordinates
      new_coordinates.coordinates.should_not be old_coordinates.coordinates
    end
  end

  describe "#from_json" do
    it "returns a LinearRing corresponding to the json" do
      first = Position.new [0, 0]
      second = Position.new [1, 0]
      third = Position.new [0, 1]
      fourth = Position.new [0, 0]

      linear_ring = LinearRing.from_json "[#{first.to_json},#{second.to_json},#{third.to_json},#{fourth.to_json}]"
      reference = LinearRing.new [first, second, third, fourth]

      linear_ring.should eq reference
    end

    it "raises for fewer than four points" do
      expect_raises(Exception, "LinearRing must have four or more points!") do
        LinearRing.from_json "[[0.0,0.0],[1.0,0.0],[0.0,0.0]]"
      end
    end

    it "raises if the first and last point don't match" do
      expect_raises(Exception, "LinearRing must have matching first and last points!") do
        LinearRing.from_json "[[0.0,0.0],[1.0,0.0],[0.0,1.0],[-1.0,0.0]]"
      end
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Position.new [0, 0]
      second = Position.new [1, 0]
      third = Position.new [0, 1]
      fourth = Position.new [0, 0]

      linear_ring = LinearRing.new [first, second, third, fourth]

      reference_json = "[#{first.to_json},#{second.to_json},#{third.to_json},#{fourth.to_json}]"

      linear_ring.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#==" do
    it "is true for the same object" do
      result = Position.new [0, 1]

      result.should eq result
    end

    it "is true for a different LinearRing with the same coordinates" do
      first = LinearRing.new(
        [Position.new([0, 0]),
         Position.new([1, 0]),
         Position.new([0, 1]),
         Position.new([0, 0])]
      )

      second = LinearRing.new(
        [Position.new([0, 0]),
         Position.new([1, 0]),
         Position.new([0, 1]),
         Position.new([0, 0])]
      )

      first.should eq second
    end

    it "is false for a different LinearRing with different coordinates" do
      first = LinearRing.new(
        [Position.new([0, 0]),
         Position.new([1, 0]),
         Position.new([0, 1]),
         Position.new([0, 0])]
      )

      second = LinearRing.new(
        [Position.new([0, 0]),
         Position.new([2, 1]),
         Position.new([1, 2]),
         Position.new([0, 0])]
      )

      first.should_not eq second
    end

    it "is true for a LineStringCoordinates with the same coordinates" do
      first = LinearRing.new(
        [Position.new([0, 0]),
         Position.new([1, 0]),
         Position.new([0, 1]),
         Position.new([0, 0])]
      )

      second = LineStringCoordinates.new(
        [Position.new([0, 0]),
         Position.new([1, 0]),
         Position.new([0, 1]),
         Position.new([0, 0])]
      )

      first.should eq second
    end

    it "is false for an object of another Coordinates subclass" do
      first = LinearRing.new(
        [Position.new([0, 0]),
         Position.new([1, 0]),
         Position.new([0, 1]),
         Position.new([0, 0])]
      )

      second = MockCoordinates(Position).new [Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1]), Position.new([0, 0])]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = LinearRing.new(
        [Position.new([0, 0]),
         Position.new([1, 0]),
         Position.new([0, 1]),
         Position.new([0, 0])]
      )

      second = "Something else"

      first.should_not eq second
    end
  end
end
