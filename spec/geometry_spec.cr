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

    it "returns the correct Point for a point string" do
      coordinates = Position.new 10, 15

      result = Geometry.from_json %({"type":"Point","coordinates":#{coordinates.to_json}})

      reference = Point.new coordinates

      result.should eq reference
    end

    it "returns the correct MultiPoint for a multipoint string" do
      first = Position.new 10, 15
      second = Position.new 20, 25

      result = Geometry.from_json %({"type":"MultiPoint","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiPoint.new Point.new(first), Point.new(second)

      result.should eq reference
    end

    it "returns the correct LineString for a linestring string" do
      coordinates = LineStringCoordinates.new Position.new(10, 15), Position.new(20, 25)

      result = Geometry.from_json %({"type":"LineString","coordinates":#{coordinates.to_json}})

      reference = LineString.new coordinates

      result.should eq reference
    end

    it "returns the correct MultiLineString for a multilinestring string" do
      first = LineStringCoordinates.new Position.new(0, 0), Position.new(0, 1)
      second = LineStringCoordinates.new Position.new(1, 0), Position.new(0, 1)

      result = Geometry.from_json %({"type":"MultiLineString","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiLineString.new LineString.new(first), LineString.new(second)

      result.should eq reference
    end

    it "returns the correct Polygon for a polygon string" do
      coordinates = PolyRings.new [Position.new(0, 0), Position.new(1, 0), Position.new(0, 1), Position.new(0, 0)]

      result = Geometry.from_json %({"type":"Polygon","coordinates":#{coordinates.to_json}})

      reference = Polygon.new coordinates

      result.should eq reference
    end

    it "returns the correct MultiPolygon for a multipolygon string" do
      first = PolyRings.new [Position.new(0, 0), Position.new(0, 1), Position.new(1, 0), Position.new(0, 0)]
      second = PolyRings.new [Position.new(0, 2), Position.new(0, 3), Position.new(1, 2), Position.new(0, 2)]

      result = Geometry.from_json %({"type":"MultiPolygon","coordinates":[#{first.to_json},#{second.to_json}]})

      reference = MultiPolygon.new Polygon.new(first), Polygon.new(second)

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
      coordinates = Position.new 10, 15
      point = Point.new coordinates

      point.to_json.should eq %({"type":"Point","coordinates":#{coordinates.to_json}})
    end
  end

  describe "#from_json" do
    it "creates a Point matching the json" do
      coordinates = Position.new 10, 15

      result = Point.from_json %({"type":"Point","coordinates":#{coordinates.to_json}})

      reference = Point.new coordinates

      result.should eq reference
    end
  end

  describe "#==" do
    it "is true for the same object" do
      result = Point.new 0, 1

      result.should eq result
    end

    it "is true for a different Point with the same coordinates" do
      first = Point.new 0, 1

      second = Point.new 0, 1

      first.should eq second
    end

    it "is false for a different Point with different coordinates" do
      first = Point.new 0, 1

      second = Point.new 1, 0

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = Point.new 0, 1

      second = "Something else"

      first.should_not eq second
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
      coordinates = LineStringCoordinates.new Position.new(10.0, 15.0), Position.new(20.0, 25.0)

      linestring = LineString.new coordinates

      reference_json = %({"type":"LineString","coordinates":#{coordinates.to_json}})

      linestring.to_json.should eq reference_json
    end
  end

  describe "#from_json" do
    it "creates a LineString matching the json" do
      coordinates = LineStringCoordinates.new Position.new(10.0, 15.0), Position.new(20.0, 25.0)

      result = LineString.from_json %({"type":"LineString","coordinates":#{coordinates.to_json}})

      reference = LineString.new coordinates

      result.should eq reference
    end
  end

  describe "#==" do
    it "is true for the same object" do
      result = LineString.new Position.new(10.0, 15.0), Position.new(20.0, 25.0)

      result.should eq result
    end

    it "is true for a different LineString with the same coordinates" do
      first = LineString.new Position.new(10.0, 15.0), Position.new(20.0, 25.0)

      second = LineString.new Position.new(10.0, 15.0), Position.new(20.0, 25.0)

      first.should eq second
    end

    it "is false for a different LineString with different coordinates" do
      first = LineString.new Position.new(10.0, 15.0), Position.new(20.0, 25.0)

      second = LineString.new Position.new(10.0, 15.0), Position.new(10.0, 13.0)

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = LineString.new Position.new(10.0, 15.0), Position.new(20.0, 25.0)

      second = "Something else"

      first.should_not eq second
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
      coordinates = PolyRings.new [Position.new(0, 0), Position.new(1, 0), Position.new(0, 1), Position.new(0, 0)]

      polygon = Polygon.new coordinates

      reference_json = %({"type":"Polygon","coordinates":#{coordinates.to_json}})

      polygon.to_json.should eq reference_json
    end
  end

  describe "#from_json" do
    it "creates a Polygon matching the json" do
      coordinates = PolyRings.new [Position.new(0, 0), Position.new(1, 0), Position.new(0, 1), Position.new(0, 0)]

      result = Polygon.from_json %({"type":"Polygon","coordinates":#{coordinates.to_json}})

      reference = Polygon.new coordinates

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

  describe "#==" do
    it "is true for the same object" do
      result = Polygon.new Position.new(0, 0), Position.new(1, 0), Position.new(0, 1)

      result.should eq result
    end

    it "is true for a different Polygon with the same coordinates" do
      first = Polygon.new Position.new(0, 0), Position.new(1, 0), Position.new(0, 1)

      second = Polygon.new Position.new(0, 0), Position.new(1, 0), Position.new(0, 1)

      first.should eq second
    end

    it "is false for a different Polygon with different coordinates" do
      first = Polygon.new Position.new(0, 0), Position.new(1, 0), Position.new(0, 1)

      second = Polygon.new Position.new(0, 0), Position.new(2, 0), Position.new(0, 5)

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = Polygon.new Position.new(0, 0), Position.new(1, 0), Position.new(0, 1)

      second = "Something else"

      first.should_not eq second
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

      collection.to_json.should eq %({"type":"GeometryCollection","geometries":[#{first.to_json},#{second.to_json}]})
    end
  end

  describe "#from_json" do
    it "creates a GeometryCollection matching the json" do
      first = Point.new 1, 5
      second = LineString.new Position.new(2, 7), Position.new(3, 1)

      result = GeometryCollection.from_json %({"type":"GeometryCollection","geometries":[#{first.to_json},#{second.to_json}]})

      reference = GeometryCollection.new first, second

      result.should eq reference
    end
  end

  describe "#==" do
    first_geometry = Point.new 1, 5
    second_geometry = LineString.new Position.new(2, 7), Position.new(3, 1)

    it "is true for the same object" do
      result = GeometryCollection.new first_geometry, second_geometry

      result.should eq result
    end

    it "is true for a different GeometryCollection with the same coordinates" do
      first = GeometryCollection.new first_geometry, second_geometry

      second = GeometryCollection.new first_geometry, second_geometry

      first.should eq second
    end

    it "is false for a different GeometryCollection with different geometries" do
      first = GeometryCollection.new first_geometry, second_geometry

      second = GeometryCollection.new second_geometry

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = GeometryCollection.new first_geometry, second_geometry

      second = "Something else"

      first.should_not eq second
    end
  end
end
