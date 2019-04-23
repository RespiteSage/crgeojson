require "../spec_helper"

describe MultiPolygon do
  describe ".new" do
    it "creates a new multipolygon with the given polygons" do
      first = Position.new [0, 0]
      second = Position.new [1, 0]
      third = Position.new [0, 1]

      polygon_one = Polygon.new [first, second, third]
      polygon_two = Polygon.new [second, first, third]

      multipolygon = MultiPolygon.new [polygon_one, polygon_two]

      multipolygon[0].should eq Polygon.new [first, second, third]
      multipolygon[1].should eq Polygon.new [second, first, third]
    end
  end

  describe "#type" do
    it %(returns "MultiPolygon") do
      polygon = Polygon.new [Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1])]

      multipolygon = MultiPolygon.new [polygon]

      multipolygon.type.should eq "MultiPolygon"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = PolyRings.new [[Position.new([0, 0]), Position.new([0, 1]), Position.new([1, 0]), Position.new([0, 0])]]
      second = PolyRings.new [[Position.new([0, 2]), Position.new([0, 3]), Position.new([1, 2]), Position.new([0, 2])]]

      multipolygon = MultiPolygon.new [Polygon.new(first), Polygon.new(second)]

      reference_json = %({"type":"MultiPolygon","coordinates":[#{first.to_json},#{second.to_json}]})

      multipolygon.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#from_json" do
    it "creates a MultiPolygon matching the json" do
      first = PolyRings.new [[Position.new([0, 0]), Position.new([0, 1]), Position.new([1, 0]), Position.new([0, 0])]]
      second = PolyRings.new [[Position.new([0, 2]), Position.new([0, 3]), Position.new([1, 2]), Position.new([0, 2])]]

      result = MultiPolygon.from_json %({"type":"MultiPolygon","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiPolygon.new [Polygon.new(first), Polygon.new(second)]

      result.should eq reference
    end
  end

  describe "#==" do
    first_polygon = Polygon.new [Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1])]
    second_polygon = Polygon.new [Position.new([0, 0]), Position.new([2, 0]), Position.new([0, 7])]

    it "is true for the same object" do
      result = MultiPolygon.new [first_polygon, second_polygon]

      result.should eq result
    end

    it "is true for a different MultiPolygon with the same coordinates" do
      first = MultiPolygon.new [first_polygon, second_polygon]

      second = MultiPolygon.new [first_polygon, second_polygon]

      first.should eq second
    end

    it "is false for a different MultiPolygon with different coordinates" do
      first = MultiPolygon.new [first_polygon, second_polygon]

      second = MultiPolygon.new [second_polygon]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = MultiPolygon.new [first_polygon, second_polygon]

      second = "Something else"

      first.should_not eq second
    end
  end
end
