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
      geometry_types = ["Point","MultiPoint","LineString","MultiLineString",
                        "Polygon","MultiPolygon","GeometryCollection"]

      geometry_types.each do |type|
        json = %({"type":"#{type}"})
        Geometry.from_json json
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
end
