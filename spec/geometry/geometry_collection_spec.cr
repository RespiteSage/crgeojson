require "../spec_helper"

describe GeometryCollection do
  describe ".new" do
    it "creates a new geometry collection with the given array of geometries" do
      first = Point.new [1, 5]
      second = LineString.new [Position.new([2, 7]), Position.new([3, 1])]

      collection = GeometryCollection.new [first, second]

      collection[0].should eq Point.new [1, 5]
      collection[1].should eq LineString.new [Position.new([2, 7]), Position.new([3, 1])]
    end
  end

  describe "#type" do
    it %(returns "GeometryCollection") do
      collection = GeometryCollection.new [Point.new [0, 0]]

      collection.type.should eq "GeometryCollection"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Point.new [1, 5]
      second = LineString.new [Position.new([2, 7]), Position.new([3, 1])]

      collection = GeometryCollection.new [first, second]

      reference_json = %({"type":"GeometryCollection","geometries":[#{first.to_json},#{second.to_json}]})

      collection.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#from_json" do
    it "creates a GeometryCollection matching the json" do
      first = Point.new [1, 5]
      second = LineString.new [Position.new([2, 7]), Position.new([3, 1])]

      result = GeometryCollection.from_json %({"type":"GeometryCollection","geometries":[#{first.to_json},#{second.to_json}]})

      reference = GeometryCollection.new [first, second]

      result.should eq reference
    end
  end

  describe "#==" do
    first_geometry = Point.new [1, 5]
    second_geometry = LineString.new [Position.new([2, 7]), Position.new([3, 1])]

    it "is true for the same object" do
      result = GeometryCollection.new [first_geometry, second_geometry]

      result.should eq result
    end

    it "is true for a different GeometryCollection with the same coordinates" do
      first = GeometryCollection.new [first_geometry, second_geometry]

      second = GeometryCollection.new [first_geometry, second_geometry]

      first.should eq second
    end

    it "is false for a different GeometryCollection with different geometries" do
      first = GeometryCollection.new [first_geometry, second_geometry]

      second = GeometryCollection.new [second_geometry]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = GeometryCollection.new [first_geometry, second_geometry]

      second = "Something else"

      first.should_not eq second
    end
  end
end
