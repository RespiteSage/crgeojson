require "../spec_helper"

describe Position do
  describe ".new" do
    it "properly sets the longitude and latitude" do
      result = Position.new [15.0, 10.0]

      result.longitude.should eq 15.0
      result.latitude.should eq 10.0
    end

    it "accepts integers" do
      result = Position.new [15, 10]

      result.longitude.should eq 15.0
      result.latitude.should eq 10.0
    end

    it "properly sets coordinates with an altivation" do
      result = Position.new [12.0, 41.0, 300.0]

      result.longitude.should eq 12.0
      result.latitude.should eq 41.0
      result.altivation.should eq 300.0
    end

    it "works with an array of floats" do
      result = Position.new [17.0, 19.0, 23.0]

      result.longitude.should eq 17.0
      result.latitude.should eq 19.0
      result.altivation.should eq 23.0
    end

    it "raises for an array with only one value" do
      expect_raises(MalformedCoordinateException, "Position must have two or three coordinates!") do
        Position.new [10.0]
      end
    end

    it "raises for an array with more than three values" do
      expect_raises(MalformedCoordinateException, "Position must have two or three coordinates!") do
        Position.new [10.0, 15.0, 20.0, 25.0]
      end
    end

    it "creates appropriate coordinates from a CoordinateTree" do
      root = Root.new
      lon = Leaf.new root, 20
      lat = Leaf.new root, -40
      alt = Leaf.new root, 45

      result = Position.new root

      result.longitude.should eq 20
      result.latitude.should eq -40
      result.altivation.should eq 45
    end
  end

  describe "#from_json" do
    it "returns a Position corresponding to the json" do
      position = Position.from_json "[10.0,15.0]"
      reference = Position.new [10.0, 15.0]

      position.should eq reference
    end

    it "raises for an array with only one value" do
      expect_raises(MalformedCoordinateException, "Position must have two or three coordinates!") do
        Position.from_json "[10.0]"
      end
    end

    it "raises for an array with more than three values" do
      expect_raises(MalformedCoordinateException, "Position must have two or three coordinates!") do
        Position.from_json "[10.0, 15.0, 20.0, 25.0]"
      end
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      position = Position.new [10.0, 15.0]

      reference_json = "[10.0,15.0]"

      position.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#==" do
    it "is true for the same object" do
      result = Position.new [0, 1]

      result.should eq result
    end

    it "is true for a different Position with the same coordinates" do
      first = Position.new [0, 1]

      second = Position.new [0, 1]

      first.should eq second
    end

    it "is false for a different Position with different coordinates" do
      first = Position.new [0, 1]

      second = Position.new [1, 0]

      first.should_not eq second
    end

    it "is false for an object of another Coordinates subclass" do
      first = Position.new [0, 1]

      second = MockCoordinates(Float64).new [0.0, 1.0]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = Position.new [0, 1]

      second = "Something else"

      first.should_not eq second
    end
  end
end
