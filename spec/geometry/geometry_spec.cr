require "../spec_helper"

describe Geometry do
  describe "#from_json" do
    it "rejects invalid geometry type" do
      expect_raises(Exception, %(Invalid geometry type "Sphere"!)) do
        Geometry.from_json %({"type":"Sphere","coordinates":[]})
      end
    end

    it "rejects missing type string" do
      expect_raises(Exception, "Type field missing!") do
        Geometry.from_json %({"kind":"Sphere","coordinates":[]})
      end
    end

    it "rejects type string with wrong type argument" do
      expect_raises(Exception, "Type field is not a string!") do
        Geometry.from_json %({"type":7})
      end
    end

    it "rejects invalid json" do
      expect_raises(JSON::ParseException) do
        Geometry.from_json %({"type": "Point","coordinates":0, 0]})
      end
    end

    it "returns the correct Point for a point string" do
      coordinates = Position.new [10, 15]

      result = Geometry.from_json %({"type":"Point","coordinates":#{coordinates.to_json}})

      reference = Point.new coordinates

      result.should eq reference
    end

    it "returns the correct MultiPoint for a multipoint string" do
      first = Position.new [10, 15]
      second = Position.new [20, 25]

      result = Geometry.from_json %({"type":"MultiPoint","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiPoint.new [Point.new(first), Point.new(second)]

      result.should eq reference
    end

    it "returns the correct LineString for a linestring string" do
      coordinates = LineStringCoordinates.new [Position.new([10, 15]), Position.new([20, 25])]

      result = Geometry.from_json %({"type":"LineString","coordinates":#{coordinates.to_json}})

      reference = LineString.new coordinates

      result.should eq reference
    end

    it "returns the correct MultiLineString for a multilinestring string" do
      first = LineStringCoordinates.new [Position.new([0, 0]), Position.new([0, 1])]
      second = LineStringCoordinates.new [Position.new([1, 0]), Position.new([0, 1])]

      result = Geometry.from_json %({"type":"MultiLineString","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiLineString.new [LineString.new(first), LineString.new(second)]

      result.should eq reference
    end

    it "returns the correct Polygon for a polygon string" do
      coordinates = PolyRings.new [[Position.new([0, 0]), Position.new([1, 0]), Position.new([0, 1]), Position.new([0, 0])]]

      result = Geometry.from_json %({"type":"Polygon","coordinates":#{coordinates.to_json}})

      reference = Polygon.new coordinates

      result.should eq reference
    end

    it "returns the correct MultiPolygon for a multipolygon string" do
      first = PolyRings.new [[Position.new([0, 0]), Position.new([0, 1]), Position.new([1, 0]), Position.new([0, 0])]]
      second = PolyRings.new [[Position.new([0, 2]), Position.new([0, 3]), Position.new([1, 2]), Position.new([0, 2])]]

      result = Geometry.from_json %({"type":"MultiPolygon","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiPolygon.new [Polygon.new(first), Polygon.new(second)]

      result.should eq reference
    end
  end
end
