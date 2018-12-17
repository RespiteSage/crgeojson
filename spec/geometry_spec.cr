require "./spec_helper"

describe Geometry do
  describe "#from_json" do
    it "rejects invalid geometry type" do
      expect_raises(Exception, %(Invalid geometry type "Sphere"!)) do
        Geometry.from_json %({"type":"Sphere"})
      end
    end

    it "rejects missing type string" do
      expect_raises(Exception, "Type field missing!") do
        Geometry.from_json %({"kind":"Sphere"})
      end
    end

    it "rejects type string with wrong type argument" do
      expect_raises(Exception, "Type field is not a string!") do
        Geometry.from_json %({"type":7})
      end
    end

    it "accepts valid geometry types" do
      geometry_strings = [%({"type":"Point","coordinates":[0,0]}),
                          %({"type":"MultiPoint","coordinates":[[0,0]]}),
                          %({"type":"LineString","coordinates":[[0,0],[0,1]]}),
                          %({"type":"MultiLineString","coordinates":[[[0,0],[0,1]],[[1,0],[0,1]]]}),
                          %({"type":"Polygon","coordinates":[[[0,0],[1,0],[0,1],[0,0]]]}),
                          %({"type":"MultiPolygon","coordinates":[[[[0,0],[0,1],[1,0],[0,0]]]]})]

      geometry_strings.each do |json|
        Geometry.from_json json
      end
    end

    it "returns the correct Point for a point string" do
      result = Geometry.from_json %({"type":"Point","coordinates":[10,15]})

      reference = Point.new 10, 15

      result.should eq reference
    end

    it "returns the correct MultiPoint for a multipoint string" do
      result = Geometry.from_json %({"type":"MultiPoint","coordinates":[[10.0,15.0],[20.0,25.0]]})

      reference = MultiPoint.new Point.new(10, 15), Point.new(20, 25)

      result.should eq reference
    end

    it "returns the correct LineString for a linestring string" do
      result = Geometry.from_json %({"type":"LineString","coordinates":[[10.0,15.0],[20.0,25.0]]})

      reference = LineString.new Position.new(10, 15), Position.new(20, 25)

      result.should eq reference
    end

    it "returns the correct MultiLineString for a multilinestring string" do
      result = Geometry.from_json %({"type":"MultiLineString","coordinates":[[[0.0,0.0],[0.0,1.0]],[[1.0,0.0],[0.0,1.0]]]})

      first = LineString.new Position.new(0, 0), Position.new(0, 1)
      second = LineString.new Position.new(1, 0), Position.new(0, 1)
      reference = MultiLineString.new first, second

      result.should eq reference
    end

    it "returns the correct Polygon for a polygon string" do
      result = Geometry.from_json %({"type":"Polygon","coordinates":[[[0.0,0.0],[1.0,0.0],[0.0,1.0],[0.0,0.0]]]})

      reference = Polygon.new Position.new(0, 0), Position.new(1, 0), Position.new(0, 1)

      result.should eq reference
    end

    it "returns the correct MultiPolygon for a multipolygon string" do
      result = Geometry.from_json %({"type":"MultiPolygon","coordinates":[[[[0.0,0.0],[0.0,1.0],[1.0,0.0],[0.0,0.0]]],[[[0.0,2.0],[0.0,3.0],[1.0,2.0],[0.0,2.0]]]]})

      first = Polygon.new Position.new(0, 0), Position.new(0, 1), Position.new(1, 0)
      second = Polygon.new Position.new(0, 2), Position.new(0, 3), Position.new(1, 2)
      reference = MultiPolygon.new first, second

      result.should eq reference
    end
  end
end

describe Point do
  describe ".new" do
    it "creates a new point with the given coordinates" do
      point = Point.new 10.0, 15.0

      point.longitude.should eq 10.0
      point.latitude.should eq 15.0
    end

    it "takes integer arguments" do
      point = Point.new 10, 15
    end

    it "creates a point with coordinates and altivation" do
      point = Point.new 12.0, 41.0, 300.0

      point.longitude.should eq 12.0
      point.latitude.should eq 41.0
      point.altivation.should eq 300.0
    end

    it "creates a point from an array" do
      point = Point.new [12.0, 41.0, 300.0]

      point.longitude.should eq 12.0
      point.latitude.should eq 41.0
      point.altivation.should eq 300.0
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
      point = Point.new 10, 15

      point.to_json.should eq %({"type":"Point","coordinates":[10.0,15.0]})
    end
  end

  describe "#from_json" do
    it "creates a Point matching the json" do
      result = Point.from_json %({"type":"Point","coordinates":[10.0,15.0]})

      reference = Point.new 10, 15

      result.should eq reference
    end
  end
end

describe LineString do
  describe ".new" do
    it "creates a new linestring with the given points" do
      first = Position.new 10, 15
      second = Position.new 20, 25

      linestring = LineString.new first, second

      linestring[0].should eq Position.new(10.0, 15.0)
      linestring[1].should eq Position.new(20.0, 25.0)
    end

    it "rejects fewer than two points" do
      point = Position.new 10, 15

      expect_raises(Exception, "LineString must have two or more points!") do
        linestring = LineString.new point
      end
    end

    it "creates a linestring from coordinate arrays" do
      linestring = LineString.new [10.0, 15.0], [20.0, 25.0]

      linestring[0].should eq Position.new(10.0, 15.0)
      linestring[1].should eq Position.new(20.0, 25.0)
    end
  end

  describe "#type" do
    it %(returns "LineString") do
      linestring = LineString.new Position.new(0, 0), Position.new(1, 0)

      linestring.type.should eq "LineString"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Position.new 10.0, 15.0
      second = Position.new 20.0, 25.0

      linestring = LineString.new first, second

      reference_json = %({"type":"LineString","coordinates":[[10.0,15.0],[20.0,25.0]]})

      linestring.to_json.should eq reference_json
    end
  end

  describe "#from_json" do
    it "creates a LineString matching the json" do
      result = LineString.from_json %({"type":"LineString","coordinates":[[10.0,15.0],[20.0,25.0]]})

      first = Position.new 10, 15
      second = Position.new 20, 25
      reference = LineString.new first, second

      result.should eq reference
    end
  end
end

describe Polygon do
  describe ".new" do
    it "creates a new polygon with the given points" do
      first = Position.new 0, 0
      second = Position.new 1, 0
      third = Position.new 0, 1

      polygon = Polygon.new first, second, third

      polygon.exterior[0].should eq Position.new 0, 0
      polygon.exterior[1].should eq Position.new 1, 0
      polygon.exterior[2].should eq Position.new 0, 1
    end

    it "raises for fewer than three arguments" do
      first = Position.new 0, 0
      second = Position.new 1, 0

      expect_raises(Exception, "Polygon must have three or more points!") do
        polygon = Polygon.new first, second
      end
    end

    it "creates a new polygon with the given rings" do
      outer_ring = LinearRing.new(
        Position.new(0, 0),
        Position.new(5, 0),
        Position.new(0, 5),
        Position.new(0, 0)
      )
      inner_ring = LinearRing.new(
        Position.new(1, 1),
        Position.new(1, 2),
        Position.new(2, 1),
        Position.new(1, 1)
      )

      polygon = Polygon.new outer_ring, inner_ring

      polygon[0].should eq LinearRing.new(
        Position.new(0, 0),
        Position.new(5, 0),
        Position.new(0, 5),
        Position.new(0, 0)
      )
      polygon[1].should eq LinearRing.new(
        Position.new(1, 1),
        Position.new(1, 2),
        Position.new(2, 1),
        Position.new(1, 1)
      )
    end

    it "creates a new polygon with an array of points" do
      first = Position.new 0, 0
      second = Position.new 1, 0
      third = Position.new 0, 1

      polygon = Polygon.new [first, second, third]

      polygon.exterior[0].should eq Position.new 0, 0
      polygon.exterior[1].should eq Position.new 1, 0
      polygon.exterior[2].should eq Position.new 0, 1
    end

    it "creates a new polygon from point arrays" do
      first = Position.new 0, 0
      second = Position.new 1, 0
      third = Position.new 0, 1

      polygon = Polygon.new [0, 0], [1, 0], [0, 1]

      polygon.exterior[0].should eq Position.new 0, 0
      polygon.exterior[1].should eq Position.new 1, 0
      polygon.exterior[2].should eq Position.new 0, 1
    end
  end

  describe "#type" do
    it %(returns "Polygon") do
      polygon = Polygon.new Position.new(0, 0), Position.new(1, 0), Position.new(0, 1)

      polygon.type.should eq "Polygon"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Position.new 0, 0
      second = Position.new 1, 0
      third = Position.new 0, 1

      polygon = Polygon.new first, second, third

      reference_json = %({"type":"Polygon","coordinates":[[[0.0,0.0],[1.0,0.0],[0.0,1.0],[0.0,0.0]]]})

      polygon.to_json.should eq reference_json
    end
  end

  describe "#from_json" do
    it "creates a Polygon matching the json" do
      result = Polygon.from_json %({"type":"Polygon","coordinates":[[[0.0,0.0],[1.0,0.0],[0.0,1.0],[0.0,0.0]]]})

      first = Position.new 0, 0
      second = Position.new 1, 0
      third = Position.new 0, 1

      reference = Polygon.new first, second, third

      result.should eq reference
    end
  end

  describe "#exterior" do
    it "returns the first LinearRing" do
      outer_ring = LinearRing.new(
        Position.new(0, 0),
        Position.new(5, 0),
        Position.new(0, 5),
        Position.new(0, 0)
      )
      inner_ring = LinearRing.new(
        Position.new(1, 1),
        Position.new(1, 2),
        Position.new(2, 1),
        Position.new(1, 1)
      )

      polygon = Polygon.new outer_ring, inner_ring

      polygon.exterior.should eq outer_ring
    end
  end
end

describe GeometryCollection do
  describe ".new" do
    it "creates a new geometry collection with the given geometries" do
      first = Point.new 1, 5
      second = LineString.new Position.new(2, 7), Position.new(3, 1)

      collection = GeometryCollection.new first, second

      collection[0].should eq Point.new 1, 5
      collection[1].should eq LineString.new Position.new(2, 7), Position.new(3, 1)
    end
  end

  describe "#type" do
    it %(returns "GeometryCollection") do
      collection = GeometryCollection.new Point.new(0, 0)

      collection.type.should eq "GeometryCollection"
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = Point.new 1, 5
      second = LineString.new Position.new(2, 7), Position.new(3, 1)

      collection = GeometryCollection.new first, second

      collection.to_json.should eq %({"type":"GeometryCollection","geometries":[{"type":"Point","coordinates":[1.0,5.0]},{"type":"LineString","coordinates":[[2.0,7.0],[3.0,1.0]]}]})
    end
  end

  describe "#from_json" do
    it "creates a GeometryCollection matching the json" do
      result = GeometryCollection.from_json %({"type":"GeometryCollection","geometries":[{"type":"Point","coordinates":[1.0,5.0]},{"type":"LineString","coordinates":[[2.0,7.0],[3.0,1.0]]}]})

      first = Point.new 1, 5
      second = LineString.new Position.new(2, 7), Position.new(3, 1)

      reference = GeometryCollection.new first, second

      result.should eq reference
    end
  end
end
