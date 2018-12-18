require "./spec_helper"

describe Position do
  describe ".new" do
    it "properly sets the longitude and latitude" do
      result = Position.new 15.0, 10.0

      result.longitude.should eq 15.0
      result.latitude.should eq 10.0
    end

    it "accepts integers" do
      result = Position.new 15, 10

      result.longitude.should eq 15.0
      result.latitude.should eq 10.0
    end

    it "properly sets coordinates with an altivation" do
      result = Position.new 12.0, 41.0, 300.0

      result.longitude.should eq 12.0
      result.latitude.should eq 41.0
      result.altivation.should eq 300.0
    end

    it "works with an array of floats" do
      result = Position.new [17.0, 19.0, 23.0]

      result.longitude.should eq 17.0
      result.latitude.should eq 19.0
      result.altivation.should eq 23.0
    end

    it "raises for an array with only one value" do
      expect_raises(MalformedCoordinateException, "Position must have two or three coordinates!") do
        Position.new [10.0]
      end
    end

    it "raises for an array with more than three values" do
      expect_raises(MalformedCoordinateException, "Position must have two or three coordinates!") do
        Position.new [10.0, 15.0, 20.0, 25.0]
      end
    end
  end

  describe "#from_json" do
    it "returns a Position corresponding to the json" do
      position = Position.from_json "[10.0,15.0]"
      reference = Position.new 10.0, 15.0

      position.should eq reference
    end

    it "raises for an array with only one value" do
      expect_raises(MalformedCoordinateException, "Position must have two or three coordinates!") do
        Position.from_json "[10.0]"
      end
    end

    it "raises for an array with more than three values" do
      expect_raises(MalformedCoordinateException, "Position must have two or three coordinates!") do
        Position.from_json "[10.0, 15.0, 20.0, 25.0]"
      end
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      position = Position.new 10.0, 15.0

      position.to_json.should eq "[10.0,15.0]"
    end
  end
end

describe LineStringCoordinates do
  describe ".new" do
    it "properly sets internal points from Positions" do
      first  = Position.new 1, 2
      second = Position.new 3, 2

      result = LineStringCoordinates.new first, second

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
    end

    it "raises for fewer than two arguments" do
      point = Position.new 10.0, 15.0

      expect_raises(Exception, "LineString must have two or more points!") do
        linestring = LineStringCoordinates.new point
      end
    end

    it "works properly with an array of Positions" do
      first  = Position.new 1, 2
      second = Position.new 3, 2

      result = LineStringCoordinates.new [first, second]

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
    end

    it "works properly with an array of arrays of floats" do
      result = LineStringCoordinates.new [[1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]]

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
      result[2].should eq Position.new 2, 0
      result[3].should eq Position.new 1, 2
    end

    it "works properly with multiple arrays of floats" do
      result = LineStringCoordinates.new [1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
      result[2].should eq Position.new 2, 0
      result[3].should eq Position.new 1, 2
    end
  end

  describe "#from_json" do
    it "returns a LineString corresponding to the json" do
      first  = Position.new 1.0, 2.0
      second = Position.new 3.0, 2.0

      linestring = LineStringCoordinates.from_json "[#{first.to_json},#{second.to_json}]"
      reference = LineStringCoordinates.new first, second

      linestring.should eq reference
    end

    it "raises for fewer than two points" do
      expect_raises(MalformedCoordinateException, "LineString must have two or more points!") do
        LineStringCoordinates.from_json "[[1.0,2.0]]"
      end
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first  = Position.new 1.0, 2.0
      second = Position.new 3.0, 2.0

      linestring = LineStringCoordinates.new first, second

      linestring.to_json.should eq "[#{first.to_json},#{second.to_json}]"
    end
  end
end

describe LinearRing do
  describe ".new" do
    it "properly sets internal points from Positions" do
      first  = Position.new 1, 2
      second = Position.new 3, 2
      third  = Position.new 2, 0
      fourth = Position.new 1, 2

      result = LinearRing.new first, second, third, fourth

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
      result[2].should eq Position.new 2, 0
      result[3].should eq Position.new 1, 2
    end

    it "raises for fewer than four arguments" do
      first  = Position.new 1, 2
      second = Position.new 3, 2
      third  = Position.new 1, 2

      expect_raises(Exception, "LinearRing must have four or more points!") do
        LinearRing.new first, second, third
      end
    end

    it "raises if the first and last argument differ" do
      first  = Position.new 1, 2
      second = Position.new 3, 2
      third  = Position.new 2, 0
      fourth = Position.new 5, 5

      expect_raises(Exception, "LinearRing must have matching first and last points!") do
        LinearRing.new first, second, third, fourth
      end
    end

    it "works properly with an array of Positions" do
      first  = Position.new 1, 2
      second = Position.new 3, 2
      third  = Position.new 2, 0
      fourth = Position.new 1, 2

      result = LinearRing.new [first, second, third, fourth]

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
      result[2].should eq Position.new 2, 0
      result[3].should eq Position.new 1, 2
    end

    it "works properly with an array of arrays of floats" do
      result = LinearRing.new [[1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]]

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
      result[2].should eq Position.new 2, 0
      result[3].should eq Position.new 1, 2
    end

    it "works properly with multiple arrays of floats" do
      result = LinearRing.new [1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]

      result[0].should eq Position.new 1, 2
      result[1].should eq Position.new 3, 2
      result[2].should eq Position.new 2, 0
      result[3].should eq Position.new 1, 2
    end
  end

  describe "#from_json" do
    it "returns a LinearRing corresponding to the json" do
      first  = Position.new 0, 0
      second = Position.new 1, 0
      third  = Position.new 0, 1
      fourth = Position.new 0, 0

      linear_ring = LinearRing.from_json "[#{first.to_json},#{second.to_json},#{third.to_json},#{fourth.to_json}]"
      reference = LinearRing.new first, second, third, fourth

      linear_ring.should eq reference
    end

    it "raises for fewer than four points" do
      expect_raises(Exception, "LinearRing must have four or more points!") do
        LinearRing.from_json "[[0.0,0.0],[1.0,0.0],[0.0,0.0]]"
      end
    end

    it "raises if the first and last point don't match" do
      expect_raises(Exception, "LinearRing must have matching first and last points!") do
        LinearRing.from_json "[[0.0,0.0],[1.0,0.0],[0.0,1.0],[-1.0,0.0]]"
      end
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first  = Position.new 0, 0
      second = Position.new 1, 0
      third  = Position.new 0, 1
      fourth = Position.new 0, 0

      linear_ring = LinearRing.new first, second, third, fourth

      linear_ring.to_json.should eq "[#{first.to_json},#{second.to_json},#{third.to_json},#{fourth.to_json}]"
    end
  end
end

describe PolyRings do
  describe ".new" do
    it "properly sets internal rings" do
      first = LinearRing.new(
        Position.new(1, 2),
        Position.new(3, 2),
        Position.new(2, 0),
        Position.new(1, 2)
      )
      second = LinearRing.new(
        Position.new(2, 3),
        Position.new(4, 3),
        Position.new(3, 1),
        Position.new(2, 3)
      )

      result = PolyRings.new first, second

      result[0].should eq LinearRing.new(
        Position.new(1, 2),
        Position.new(3, 2),
        Position.new(2, 0),
        Position.new(1, 2)
      )
      result[1].should eq LinearRing.new(
        Position.new(2, 3),
        Position.new(4, 3),
        Position.new(3, 1),
        Position.new(2, 3)
      )
    end

    it "works properly with an array of rings" do
      first = LinearRing.new(
        Position.new(1, 2),
        Position.new(3, 2),
        Position.new(2, 0),
        Position.new(1, 2)
      )
      second = LinearRing.new(
        Position.new(2, 3),
        Position.new(4, 3),
        Position.new(3, 1),
        Position.new(2, 3)
      )

      result = PolyRings.new [first, second]

      result[0].should eq LinearRing.new(
        Position.new(1, 2),
        Position.new(3, 2),
        Position.new(2, 0),
        Position.new(1, 2)
      )
      result[1].should eq LinearRing.new(
        Position.new(2, 3),
        Position.new(4, 3),
        Position.new(3, 1),
        Position.new(2, 3)
      )
    end

    it "works properly with an array of arrays of positions" do
      first = [Position.new(1.0, 2.0), Position.new(3.0, 2.0),
               Position.new(2.0, 0.0), Position.new(1.0, 2.0)]
      second = [Position.new(2.0, 3.0), Position.new(4.0, 3.0),
                Position.new(3.0, 1.0), Position.new(2.0, 3.0)]

      result = PolyRings.new [first, second]

      result[0].should eq LinearRing.new(
        Position.new(1, 2),
        Position.new(3, 2),
        Position.new(2, 0),
        Position.new(1, 2)
      )
      result[1].should eq LinearRing.new(
        Position.new(2, 3),
        Position.new(4, 3),
        Position.new(3, 1),
        Position.new(2, 3)
      )
    end

    it "works properly with an array of arrays of arrays of floats" do
      result = PolyRings.new [[[1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]],
                              [[2.0, 3.0], [4.0, 3.0], [3.0, 1.0], [2.0, 3.0]]]

      result[0].should eq LinearRing.new(
        Position.new(1, 2),
        Position.new(3, 2),
        Position.new(2, 0),
        Position.new(1, 2)
      )
      result[1].should eq LinearRing.new(
        Position.new(2, 3),
        Position.new(4, 3),
        Position.new(3, 1),
        Position.new(2, 3)
      )
    end

    it "works properly with multiple arrays of arrays of floats" do
      result = PolyRings.new [[1.0, 2.0], [3.0, 2.0], [2.0, 0.0], [1.0, 2.0]],
        [[2.0, 3.0], [4.0, 3.0], [3.0, 1.0], [2.0, 3.0]]

      result[0].should eq LinearRing.new(
        Position.new(1, 2),
        Position.new(3, 2),
        Position.new(2, 0),
        Position.new(1, 2)
      )
      result[1].should eq LinearRing.new(
        Position.new(2, 3),
        Position.new(4, 3),
        Position.new(3, 1),
        Position.new(2, 3)
      )
    end
  end

  describe "#from_json" do
    it "returns PolyRings corresponding to the json" do
      first = LinearRing.new(
        Position.new(1, 2),
        Position.new(3, 2),
        Position.new(2, 0),
        Position.new(1, 2)
      )
      second = LinearRing.new(
        Position.new(2, 3),
        Position.new(4, 3),
        Position.new(3, 1),
        Position.new(2, 3)
      )

      polyrings = PolyRings.from_json %([#{first.to_json},#{second.to_json}])
      reference = PolyRings.new first, second

      polyrings.should eq reference
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      first = LinearRing.new(
        Position.new(1, 2),
        Position.new(3, 2),
        Position.new(2, 0),
        Position.new(1, 2)
      )
      second = LinearRing.new(
        Position.new(2, 3),
        Position.new(4, 3),
        Position.new(3, 1),
        Position.new(2, 3)
      )

      polyrings = PolyRings.new first, second

      polyrings.to_json.should eq %([#{first.to_json},#{second.to_json}])
    end
  end
end
