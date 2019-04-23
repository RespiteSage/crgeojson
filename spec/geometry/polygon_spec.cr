require "../spec_helper"

describe Polygon do
  describe ".new" do
    it "creates a new polygon with the given points" do
      first = Position.new [0, 0]
      second = Position.new [1, 0]
      third = Position.new [0, 1]

      polygon = Polygon.new [first, second, third]

      polygon.exterior[0].should eq Position.new [0, 0]
      polygon.exterior[1].should eq Position.new [1, 0]
      polygon.exterior[2].should eq Position.new [0, 1]
    end

    it "raises for fewer than three arguments" do
      first = Position.new [0, 0]
      second = Position.new [1, 0]

      expect_raises(Exception, "Polygon must have three or more points!") do
        polygon = Polygon.new [first, second]
      end
    end

    it "creates a new polygon with the given rings" do
      outer_ring = LinearRing.new(
        [Position.new([0, 0]),
         Position.new([5, 0]),
         Position.new([0, 5]),
         Position.new([0, 0])]
      )
      inner_ring = LinearRing.new(
        [Position.new([1, 1]),
         Position.new([1, 2]),
         Position.new([2, 1]),
         Position.new([1, 1])]
      )

      polygon = Polygon.new [outer_ring, inner_ring]

      polygon[0].should eq LinearRing.new(
        [Position.new([0, 0]),
         Position.new([5, 0]),
         Position.new([0, 5]),
         Position.new([0, 0])]
      )
      polygon[1].should eq LinearRing.new(
        [Position.new([1, 1]),
         Position.new([1, 2]),
         Position.new([2, 1]),
         Position.new([1, 1])]
      )
    end

    it "creates a new polygon with an array of points" do
      first = Position.new [0, 0]
      second = Position.new [1, 0]
      third = Position.new [0, 1]

      polygon = Polygon.new [first, second, third]

      polygon.exterior[0].should eq Position.new [0, 0]
      polygon.exterior[1].should eq Position.new [1, 0]
      polygon.exterior[2].should eq Position.new [0, 1]
    end

    it "creates a new polygon from an array of point arrays" do
      first = Position.new [0, 0]
      second = Position.new [1, 0]
      third = Position.new [0, 1]

      polygon = Polygon.new [[0, 0], [1, 0], [0, 1]]

      polygon.exterior[0].should eq Position.new [0, 0]
      polygon.exterior[1].should eq Position.new [1, 0]
      polygon.exterior[2].should eq Position.new [0, 1]
    end
  end

  describe "#type" do
    it %(returns "Polygon") do
      polygon = Polygon.new [Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1])]

      polygon.type.should eq "Polygon"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      coordinates = PolyRings.new [[Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1]), Position.new([0, 0])]]

      polygon = Polygon.new coordinates

      reference_json = %({"type":"Polygon","coordinates":#{coordinates.to_json}})

      polygon.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#from_json" do
    it "creates a Polygon matching the json" do
      coordinates = PolyRings.new [[Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1]), Position.new([0, 0])]]

      result = Polygon.from_json %({"type":"Polygon","coordinates":#{coordinates.to_json}})

      reference = Polygon.new coordinates

      result.should eq reference
    end
  end

  describe "#exterior" do
    it "returns the first LinearRing" do
      outer_ring = LinearRing.new(
        [Position.new([0, 0]),
         Position.new([5, 0]),
         Position.new([0, 5]),
         Position.new([0, 0])]
      )
      inner_ring = LinearRing.new(
        [Position.new([1, 1]),
         Position.new([1, 2]),
         Position.new([2, 1]),
         Position.new([1, 1])]
      )

      polygon = Polygon.new [outer_ring, inner_ring]

      polygon.exterior.should eq outer_ring
    end
  end

  describe "#==" do
    it "is true for the same object" do
      result = Polygon.new [Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1])]

      result.should eq result
    end

    it "is true for a different Polygon with the same coordinates" do
      first = Polygon.new [Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1])]

      second = Polygon.new [Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1])]

      first.should eq second
    end

    it "is false for a different Polygon with different coordinates" do
      first = Polygon.new [Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1])]

      second = Polygon.new [Position.new([0, 0]), Position.new([2, 0]), Position.new([0, 5])]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = Polygon.new [Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1])]

      second = "Something else"

      first.should_not eq second
    end
  end
end
