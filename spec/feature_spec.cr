require "./spec_helper"

describe Feature do
  describe ".new" do
    it "sets a geometry and leaves properties and id unset" do
      geometry = Point.new 0, 0

      feature = Feature.new geometry

      feature.geometry.should eq Point.new 0, 0
      feature.properties.should be_nil
      feature.id.should be_nil
    end

    it "sets geometry and properties, leaving id unset" do
      geometry = Point.new 1, 0

      properties = {"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type

      feature = Feature.new geometry, properties

      feature.geometry.should eq Point.new 1, 0
      feature.properties.should eq ({"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type)
      feature.id.should be_nil
    end

    it "sets geometry and id as a number, leaving properties unset" do
      geometry = Point.new 4, 9

      feature = Feature.new geometry, id: 43

      feature.geometry.should eq Point.new 4, 9
      feature.properties.should be_nil
      feature.id.should eq 43
    end

    it "sets geometry and id as a string, leaving properties unset" do
      geometry = LineString.new [0, 0], [1, 4]

      feature = Feature.new geometry, id: "forty-three"

      feature.geometry.should eq LineString.new [0, 0], [1, 4]
      feature.properties.should be_nil
      feature.id.should eq "forty-three"
    end

    it "sets geometry, properties, and id" do
      geometry = Point.new 1, 0

      properties = {"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type

      feature = Feature.new geometry, properties, id: 43

      feature.geometry.should eq Point.new 1, 0
      feature.properties.should eq ({"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type)
      feature.id.should eq 43
    end

    it "allows setting geometry as nil" do
      feature = Feature.new nil

      feature.geometry.should be_nil
      feature.properties.should be_nil
      feature.id.should be_nil
    end
  end

  describe "#type" do
    it %(returns "Feature") do
      feature = Feature.new Point.new(0, 0)

      feature.type.should eq "Feature"
    end
  end

  describe "#to_json" do
    it "returns accurate json" do
      geometry = Point.new 1, 0

      properties = {"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type

      feature = Feature.new geometry, properties, id: 43

      feature.to_json.should eq %({"type":"Feature","geometry":{"type":"Point","coordinates":[1.0,0.0]},"properties":{"color":"0xFF00FF","layer":2},"id":43})
    end

    it "does not output any id when it is unset" do
      geometry = Point.new 1, 0

      properties = {"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type

      feature = Feature.new geometry, properties

      feature.to_json.should eq %({"type":"Feature","geometry":{"type":"Point","coordinates":[1.0,0.0]},"properties":{"color":"0xFF00FF","layer":2}})
    end

    it "outputs null value for unset properties" do
      geometry = Point.new 1, 0

      feature = Feature.new geometry, id: 43

      feature.to_json.should eq %({"type":"Feature","geometry":{"type":"Point","coordinates":[1.0,0.0]},"properties":null,"id":43})
    end

    it "outputs null value for nil geometry" do
      properties = {"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type

      feature = Feature.new nil, properties, id: 43

      feature.to_json.should eq %({"type":"Feature","geometry":null,"properties":{"color":"0xFF00FF","layer":2},"id":43})
    end
  end

  describe "#from_json" do
    it "creates a Feature from the matching json" do
      result = Feature.from_json %({"type":"Feature","geometry":{"type":"Point","coordinates":[1.0,0.0]},"properties":{"layer":2},"id":43})

      reference = Feature.new Point.new(1, 0), {"layer" => 2_i64} of String => JSON::Any::Type, id: 43

      result.should eq reference
    end

    it "creates a Feature from json with a missing id" do
      result = Feature.from_json %({"type":"Feature","geometry":{"type":"Point","coordinates":[1.0,0.0]},"properties":{"layer":2}})

      reference = Feature.new Point.new(1, 0), {"layer" => 2_i64} of String => JSON::Any::Type

      result.should eq reference
    end

    it "creates a Feature from json with null properties" do
      result = Feature.from_json %({"type":"Feature","geometry":{"type":"Point","coordinates":[1.0,0.0]},"properties":null,"id":43})

      reference = Feature.new Point.new(1, 0), id: 43

      result.should eq reference
    end

    it "creates a Feature from json with a null geometry" do
      result = Feature.from_json %({"type":"Feature","geometry":null,"properties":{"layer":2},"id":43})

      reference = Feature.new nil, {"layer" => 2_i64} of String => JSON::Any::Type, id: 43

      result.should eq reference
    end
  end
end
