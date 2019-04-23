require "../spec_helper"

describe PolyRings do
  describe ".new" do
    it "properly sets internal rings" do
      first = LinearRing.new(
        [Position.new([1, 2]),
         Position.new([3, 2]),
         Position.new([2, 0]),
         Position.new([1, 2])]
      )
      second = LinearRing.new(
        [Position.new([2, 3]),
         Position.new([4, 3]),
         Position.new([3, 1]),
         Position.new([2, 3])]
      )

      result = PolyRings.new [first, second]

      result[0].should eq LinearRing.new(
        [Position.new([1, 2]),
         Position.new([3, 2]),
         Position.new([2, 0]),
         Position.new([1, 2])]
      )
      result[1].should eq LinearRing.new(
        [Position.new([2, 3]),
         Position.new([4, 3]),
         Position.new([3, 1]),
         Position.new([2, 3])]
      )
    end

    it "works properly with an array of rings" do
      first = LinearRing.new(
        [Position.new([1, 2]),
         Position.new([3, 2]),
         Position.new([2, 0]),
         Position.new([1, 2])]
      )
      second = LinearRing.new(
        [Position.new([2, 3]),
         Position.new([4, 3]),
         Position.new([3, 1]),
         Position.new([2, 3])]
      )

      result = PolyRings.new [first, second]

      result[0].should eq LinearRing.new(
        [Position.new([1, 2]),
         Position.new([3, 2]),
         Position.new([2, 0]),
         Position.new([1, 2])]
      )
      result[1].should eq LinearRing.new(
        [Position.new([2, 3]),
         Position.new([4, 3]),
         Position.new([3, 1]),
         Position.new([2, 3])]
      )
    end

    it "works properly with an array of arrays of positions" do
      first = [Position.new([1.0, 2.0]), Position.new([3.0, 2.0]),
               Position.new([2.0, 0.0]), Position.new([1.0, 2.0])]
      second = [Position.new([2.0, 3.0]), Position.new([4.0, 3.0]),
                Position.new([3.0, 1.0]), Position.new([2.0, 3.0])]

      result = PolyRings.new [first, second]

      result[0].should eq LinearRing.new(
        [Position.new([1, 2]),
         Position.new([3, 2]),
         Position.new([2, 0]),
         Position.new([1, 2])]
      )
      result[1].should eq LinearRing.new(
        [Position.new([2, 3]),
         Position.new([4, 3]),
         Position.new([3, 1]),
         Position.new([2, 3])]
      )
    end

    it "works properly with an array of arrays of arrays of floats" do
      result = PolyRings.new [[[1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]],
                              [[2.0, 3.0], [4.0, 3.0], [3.0, 1.0], [2.0, 3.0]]]

      result[0].should eq LinearRing.new(
        [Position.new([1, 2]),
         Position.new([3, 2]),
         Position.new([2, 0]),
         Position.new([1, 2])]
      )
      result[1].should eq LinearRing.new(
        [Position.new([2, 3]),
         Position.new([4, 3]),
         Position.new([3, 1]),
         Position.new([2, 3])]
      )
    end

    it "creates appropriate coordinates from a CoordinateTree" do
      root = Root.new
      first_ring = Branch.new root
      first_position = Branch.new first_ring
      first_position_lon = Leaf.new first_position, 2
      first_position_lat = Leaf.new first_position, 3
      second_position = Branch.new first_ring
      second_position_lon = Leaf.new second_position, 5
      second_position_lat = Leaf.new second_position, 7
      third_position = Branch.new first_ring
      third_position_lon = Leaf.new third_position, 11
      third_position_lat = Leaf.new third_position, 13
      fourth_position = Branch.new first_ring
      fourth_position_lon = Leaf.new fourth_position, 2
      fourth_position_lat = Leaf.new fourth_position, 3

      result = PolyRings.new root

      result.should eq PolyRings.new [[[2, 3], [5, 7], [11, 13], [2, 3]]]
    end
  end

  describe "#from_json" do
    it "returns PolyRings corresponding to the json" do
      first = LinearRing.new(
        [Position.new([1, 2]),
         Position.new([3, 2]),
         Position.new([2, 0]),
         Position.new([1, 2])]
      )
      second = LinearRing.new(
        [Position.new([2, 3]),
         Position.new([4, 3]),
         Position.new([3, 1]),
         Position.new([2, 3])]
      )

      polyrings = PolyRings.from_json %([#{first.to_json},#{second.to_json}])
      reference = PolyRings.new [first, second]

      polyrings.should eq reference
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = LinearRing.new(
        [Position.new([1, 2]),
         Position.new([3, 2]),
         Position.new([2, 0]),
         Position.new([1, 2])]
      )
      second = LinearRing.new(
        [Position.new([2, 3]),
         Position.new([4, 3]),
         Position.new([3, 1]),
         Position.new([2, 3])]
      )

      polyrings = PolyRings.new [first, second]

      reference_json = %([#{first.to_json},#{second.to_json}])

      polyrings.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#==" do
    first_ring = LinearRing.new(
      [Position.new([1, 2]),
       Position.new([3, 2]),
       Position.new([2, 0]),
       Position.new([1, 2])]
    )
    second_ring = LinearRing.new(
      [Position.new([2, 3]),
       Position.new([4, 3]),
       Position.new([3, 1]),
       Position.new([2, 3])]
    )

    it "is true for the same object" do
      result = PolyRings.new [first_ring, second_ring]

      result.should eq result
    end

    it "is true for a different PolyRings with the same coordinates" do
      first = PolyRings.new [first_ring, second_ring]

      second = PolyRings.new [first_ring, second_ring]

      first.should eq second
    end

    it "is false for a different PolyRings with different coordinates" do
      first = PolyRings.new [first_ring, second_ring]

      second = PolyRings.new [second_ring]

      first.should_not eq second
    end

    it "is false for an object of another Coordinates subclass" do
      first = PolyRings.new [first_ring, second_ring]

      second = MockCoordinates(LinearRing).new [first_ring, second_ring]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = PolyRings.new [first_ring, second_ring]

      second = "Something else"

      first.should_not eq second
    end
  end
end
