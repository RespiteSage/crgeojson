require "../spec_helper"

describe MultiPoint do
  describe ".new" do
    it "creates a multipoint with the given points" do
      first = Point.new [10.0, 15.0]
      second = Point.new [20.0, 25.0]

      multipoint = MultiPoint.new [first, second]

      multipoint[0].should eq Point.new [10.0, 15.0]
      multipoint[1].should eq Point.new [20.0, 25.0]
    end

    it "creates a multipoint from Positions" do
      first = Position.new [10.0, 15.0]
      second = Position.new [20.0, 25.0]

      multipoint = MultiPoint.new [first, second]

      multipoint[0].should eq Point.new [10.0, 15.0]
      multipoint[1].should eq Point.new [20.0, 25.0]
    end

    it "creates a multipoint from a CoordinateTree" do
      root = Root.new
      first_point = Branch.new root
      first_point_lon = Leaf.new first_point, 2
      first_point_lat = Leaf.new first_point, 3
      second_point = Branch.new root
      second_point_lon = Leaf.new second_point, 5
      second_point_lat = Leaf.new second_point, 7

      result = MultiPoint.new root

      result[0].should eq Point.new [2, 3]
      result[1].should eq Point.new [5, 7]
    end
  end

  describe "#type" do
    it %(returns "MultiPoint") do
      multipoint = MultiPoint.new [Point.new [0, 0]]

      multipoint.type.should eq "MultiPoint"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Position.new [10.0, 15.0]
      second = Position.new [20.0, 25.0]

      multipoint = MultiPoint.new [Point.new(first), Point.new(second)]

      reference_json = %({"type":"MultiPoint","coordinates":[#{first.to_json},#{second.to_json}]})

      multipoint.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#from_json" do
    it "creates a MultiPoint matching the json" do
      first = Position.new [10.0, 15.0]
      second = Position.new [20.0, 25.0]

      result = MultiPoint.from_json %({"type":"MultiPoint","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiPoint.new [Point.new(first), Point.new(second)]

      result.should eq reference
    end
  end

  describe "#==" do
    first_point = Point.new [10.0, 15.0]
    second_point = Point.new [20.0, 25.0]

    it "is true for the same object" do
      result = MultiPoint.new [first_point, second_point]

      result.should eq result
    end

    it "is true for a different MultiPoint with the same coordinates" do
      first = MultiPoint.new [first_point, second_point]

      second = MultiPoint.new [first_point, second_point]

      first.should eq second
    end

    it "is false for a different MultiPoint with different coordinates" do
      first = MultiPoint.new [first_point, second_point]

      second = MultiPoint.new [second_point]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = MultiPoint.new [first_point, second_point]

      second = "Something else"

      first.should_not eq second
    end
  end
end
