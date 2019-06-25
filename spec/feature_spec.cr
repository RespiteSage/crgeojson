require "./spec_helper"

describe Feature do
  describe ".new" do
    it "sets a geometry and leaves properties and id unset" do
      geometry = Point.new [0, 0]

      feature = Feature.new geometry

      feature.geometry.should eq geometry
      feature.properties.should be_nil
      feature.id.should be_nil
    end

    it "sets geometry and properties, leaving id unset" do
      geometry = Point.new [1, 0]

      properties = {"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type

      feature = Feature.new geometry, properties

      feature.geometry.should eq geometry
      feature.properties.should eq properties
      feature.id.should be_nil
    end

    it "sets geometry and id as a number, leaving properties unset" do
      geometry = Point.new [4, 9]

      feature = Feature.new geometry, id: 43

      feature.geometry.should eq geometry
      feature.properties.should be_nil
      feature.id.should eq 43
    end

    it "sets geometry and id as a string, leaving properties unset" do
      geometry = LineString.new [[0, 0], [1, 4]]

      feature = Feature.new geometry, id: "forty-three"

      feature.geometry.should eq geometry
      feature.properties.should be_nil
      feature.id.should eq "forty-three"
    end

    it "sets geometry, properties, and id" do
      geometry = Point.new [1, 0]

      properties = {"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type

      feature = Feature.new geometry, properties, id: 43

      feature.geometry.should eq geometry
      feature.properties.should eq properties
      feature.id.should eq 43
    end

    it "allows setting geometry as nil" do
      feature = Feature.new nil

      feature.geometry.should be_nil
      feature.properties.should be_nil
      feature.id.should be_nil
    end

    it "can set geometry to a GeometryCollection" do
      geometry_collection = GeometryCollection.new [Point.new([0, 0])]

      feature = Feature.new geometry_collection

      feature.geometry.should eq geometry_collection
    end
  end

  describe "#type" do
    it %(returns "Feature") do
      feature = Feature.new Point.new([0, 0])

      feature.type.should eq "Feature"
    end
  end

  describe "#to_json" do
    it "returns accurate json" do
      geometry = Point.new [1, 0]

      properties = {"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type

      feature = Feature.new geometry, properties, id: 43

      reference_json = %({"type":"Feature","geometry":#{geometry.to_json},"properties":{"color":"0xFF00FF","layer":2},"id":43})

      feature.to_json.should be_equivalent_json_to reference_json
    end

    it "does not output any id when it is unset" do
      geometry = Point.new [1, 0]

      properties = {"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type

      feature = Feature.new geometry, properties

      reference_json = %({"type":"Feature","geometry":#{geometry.to_json},"properties":{"color":"0xFF00FF","layer":2}})

      feature.to_json.should be_equivalent_json_to reference_json
    end

    it "outputs null value for unset properties" do
      geometry = Point.new [1, 0]

      feature = Feature.new geometry, id: 43

      reference_json = %({"type":"Feature","geometry":#{geometry.to_json},"properties":null,"id":43})

      feature.to_json.should be_equivalent_json_to reference_json
    end

    it "outputs null value for nil geometry" do
      properties = {"color" => "0xFF00FF", "layer" => 2_i64} of String => JSON::Any::Type

      feature = Feature.new nil, properties, id: 43

      reference_json = %({"type":"Feature","geometry":null,"properties":{"color":"0xFF00FF","layer":2},"id":43})

      feature.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#from_json" do
    it "creates a Feature from the matching json" do
      geometry = Point.new [1, 0]

      result = Feature.from_json %({"type":"Feature","geometry":#{geometry.to_json},"properties":{"layer":2},"id":43})

      reference = Feature.new geometry, {"layer" => 2_i64} of String => JSON::Any::Type, id: 43

      result.should eq reference
    end

    it "creates a Feature from json with a missing id" do
      geometry = Point.new [1, 0]

      result = Feature.from_json %({"type":"Feature","geometry":#{geometry.to_json},"properties":{"layer":2}})

      reference = Feature.new geometry, {"layer" => 2_i64} of String => JSON::Any::Type

      result.should eq reference
    end

    it "creates a Feature from json with null properties" do
      geometry = Point.new [1, 0]

      result = Feature.from_json %({"type":"Feature","geometry":#{geometry.to_json},"properties":null,"id":43})

      reference = Feature.new geometry, id: 43

      result.should eq reference
    end

    it "creates a Feature from json with a null geometry" do
      result = Feature.from_json %({"type":"Feature","geometry":null,"properties":{"layer":2},"id":43})

      reference = Feature.new nil, {"layer" => 2_i64} of String => JSON::Any::Type, id: 43

      result.should eq reference
    end
  end

  describe "#==" do
    geometry = Point.new [0, 1]
    properties = {"layer" => 2_i64} of String => JSON::Any::Type
    id = 43

    it "is true for the same object" do
      result = Feature.new geometry, properties, id: id

      result.should eq result
    end

    it "is true for a different Feature with the same geometry, properties, and id" do
      first = Feature.new geometry, properties, id: id

      second = Feature.new geometry, properties, id: id

      first.should eq second
    end

    it "is false for a different Feature with a different id" do
      first = Feature.new geometry, properties, id: id

      other_id = "forty-three"

      second = Feature.new geometry, properties, id: other_id

      first.should_not eq second
    end

    it "is false for a different Feature with different properties" do
      first = Feature.new geometry, properties, id: id

      other_properties = {"layer" => 7_i64} of String => JSON::Any::Type

      second = Feature.new geometry, other_properties, id: id

      first.should_not eq second
    end

    it "is false for a different Feature with a different geometry" do
      first = Feature.new geometry, properties, id: id

      other_geometry = Point.new [7, 1]

      second = Feature.new other_geometry, properties, id: id

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = Feature.new geometry, properties, id: id

      second = "Something else"

      first.should_not eq second
    end
  end
end
