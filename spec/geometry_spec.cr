require "./spec_helper"

describe Geometry do
  describe "#from_json" do
    it "rejects invalid geometry type" do
      expect_raises(Exception, "Invalid geometry type!") do
        Geometry.from_json %({"type":"Sphere"})
      end
    end

    it "rejects missing type string" do
      expect_raises(Exception, "Type field invalid or missing!") do
        Geometry.from_json %({"kind":"Sphere"})
      end
    end

    it "accepts valid geometry types" do
      geometry_strings = [%({"type":"Point","coordinates":[0,0]}),
                          %({"type":"MultiPoint","coordinates":[[0,0]]}),
                          %({"type":"LineString","coordinates":[[0,0],[0,1]]}),
                          %({"type":"MultiLineString","coordinates":[[[0,0],[0,1]],[[1,0],[0,1]]]}),
                          %({"type":"Polygon","coordinates":[[[0,0],[1,0],[0,1],[0,0]]]}),
                          %({"type":"MultiPolygon","coordinates":[[[[0,0],[0,1],[1,0],[0,0]]]]}),
                          %({"type":"GeometryCollection","geometries":[{"type":"Point","coordinates":[0,0]}]})]

      geometry_strings.each do |json|
        Geometry.from_json json
      end

      it "returns a Point for a point string" do
        result = Geometry.from_json %({"type":"Point","coordinates":[0,0]})

        result.should be_a Point
      end

      it "returns the correct Point for a point string" do
        result = Geometry.from_json %({"type":"Point","coordinates":[10,15]})

        reference = Point.new 10, 15

        result.should eq reference
      end
    end
  end

end

describe Point do
  describe ".new" do
    it "creates a new point with the given coordinates" do
      point = Point.new 10.0, 15.0

      point.lon.should eq 10.0
      point.lat.should eq 15.0
    end

    it "takes integer arguments" do
      point = Point.new 10, 15
    end
  end

  describe "#type" do
    it %(returns "Point") do
      point = Point.new 0, 0

      point.type.should eq "Point"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      point = Point.new 10.0, 15.0

      point.to_json.should eq %({"type":"Point","coordinates":[10.0,15.0]})
    end
  end

  describe "#from_json" do
    it "creates a Point matching the json" do
      result = Point.from_json %({"type":"Point","coordinates":[10.0,15.0]})

      reference = Point.new 10.0, 15.0

      result.should eq reference
    end
  end
end

describe MultiPoint do
  describe ".new" do
    it "creates a new multipoint with the given points" do
      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0

      multipoint = MultiPoint.new first, second

      multipoint[0].should eq Position.new(10.0, 15.0)
      multipoint[1].should eq Position.new(20.0, 25.0)
    end
  end

  describe "#type" do
    it %(returns "Point") do
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
    it "creates a Point matching the json" do
      result = MultiPoint.from_json %({"type":"MultiPoint","coordinates":[[10.0,15.0],[20.0,25.0]]})

      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0
      reference = MultiPoint.new first, second

      result.should eq reference
    end
  end
end
