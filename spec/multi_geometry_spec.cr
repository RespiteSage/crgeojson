require "./spec_helper"

describe MultiPoint do
  describe ".new" do
    it "creates a new multipoint with the given points" do
      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0

      multipoint = MultiPoint.new first, second

      multipoint[0].should eq Point.new(10.0, 15.0)
      multipoint[1].should eq Point.new(20.0, 25.0)
    end
  end

  describe "#type" do
    it %(returns "MultiPoint") do
      multipoint = MultiPoint.new Position.new(0,0)

      multipoint.type.should eq "MultiPoint"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0

      multipoint = MultiPoint.new first, second

      reference_json = %({"type":"MultiPoint","coordinates":[[10.0,15.0],[20.0,25.0]]})

      multipoint.to_json.should eq reference_json
    end
  end

  describe "#from_json" do
    it "creates a MultiPoint matching the json" do
      result = MultiPoint.from_json %({"type":"MultiPoint","coordinates":[[10.0,15.0],[20.0,25.0]]})

      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0
      reference = MultiPoint.new first, second

      result.should eq reference
    end
  end
end

describe MultiLineString do
  describe ".new" do
    it "creates a new multilinestring with the given points" do
      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0

      linestring = LineString.new first, second

      multilinestring = MultiLineString.new linestring

      multilinestring[0].should eq LineString.new(Position.new(10.0,15.0),Position.new(20.0,25.0))
    end
  end

  describe "#type" do
    it %(returns "MultiLineString") do
      linestring = LineString.new Position.new(0,0), Position.new(1,0)

      multilinestring = MultiLineString.new linestring

      multilinestring.type.should eq "MultiLineString"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Position.new 0.0, 0.0
      second = Position.new 0.0, 1.0
      third = Position.new 1.0, 0.0
      fourth = Position.new 0.0, 1.0

      linestring_one = LineString.new first, second
      linestring_two = LineString.new third, fourth

      multilinestring = MultiLineString.new linestring_one, linestring_two

      reference_json = %({"type":"MultiLineString","coordinates":[[[0.0,0.0],[0.0,1.0]],[[1.0,0.0],[0.0,1.0]]]})

      multilinestring.to_json.should eq reference_json
    end
  end

  describe "#from_json" do
    it "creates a MultiLineString matching the json" do
      result = MultiLineString.from_json %({"type":"MultiLineString","coordinates":[[[0.0,0.0],[0.0,1.0]],[[1.0,0.0],[0.0,1.0]]]})

      first = Position.new 0.0, 0.0
      second = Position.new 0.0, 1.0
      third = Position.new 1.0, 0.0
      fourth = Position.new 0.0, 1.0

      linestring_one = LineString.new first, second
      linestring_two = LineString.new third, fourth
      reference = MultiLineString.new linestring_one, linestring_two

      result.should eq reference
    end
  end
end

describe MultiPolygon do
  describe ".new" do
    it "creates a new multipolygon with the given polygons" do
      first  = Position.new 0,0
      second = Position.new 1,0
      third  = Position.new 0,1

      polygon_one = Polygon.new first, second, third
      polygon_two = Polygon.new second, first, third

      multipolygon = MultiPolygon.new polygon_one, polygon_two

      multipolygon[0].should eq Polygon.new first, second, third
      multipolygon[1].should eq Polygon.new second, first, third
    end
  end

  describe "#type" do
    it %(returns "MultiPolygon") do
      polygon = Polygon.new Position.new(0,0), Position.new(1,0), Position.new(0,1)

      multipolygon = MultiPolygon.new polygon

      multipolygon.type.should eq "MultiPolygon"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first  = Polygon.new Position.new(0,0), Position.new(0,1), Position.new(1,0)
      second = Polygon.new Position.new(0,2), Position.new(0,3), Position.new(1,2)

      multipolygon = MultiPolygon.new first, second

      reference_json = %({"type":"MultiPolygon","coordinates":[[[[0.0,0.0],[0.0,1.0],[1.0,0.0],[0.0,0.0]]],[[[0.0,2.0],[0.0,3.0],[1.0,2.0],[0.0,2.0]]]]})

      multipolygon.to_json.should eq reference_json
    end
  end

  describe "#from_json" do
    it "creates a MultiPolygon matching the json" do
      result = MultiPolygon.from_json %({"type":"MultiPolygon","coordinates":[[[[0.0,0.0],[0.0,1.0],[1.0,0.0],[0.0,0.0]]],[[[0.0,2.0],[0.0,3.0],[1.0,2.0],[0.0,2.0]]]]})

      first  = Polygon.new Position.new(0,0), Position.new(0,1), Position.new(1,0)
      second = Polygon.new Position.new(0,2), Position.new(0,3), Position.new(1,2)

      reference = MultiPolygon.new first, second

      result.should eq reference
    end
  end
end
