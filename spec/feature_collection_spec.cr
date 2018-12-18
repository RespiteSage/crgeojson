require "./spec_helper"

describe FeatureCollection do
  describe ".new" do
    it "sets the feature array" do
      collection = FeatureCollection.new [Feature.new(Point.new(1, 0)), Feature.new(Point.new(0, 7))]

      collection.features[0].should eq Feature.new(Point.new(1, 0))
      collection.features[1].should eq Feature.new(Point.new(0, 7))
    end

    it "allows an empty array" do
      collection = FeatureCollection.new [] of Feature

      collection.features.should eq ([] of Feature)
    end
  end

  describe "#type" do
    it %(returns "FeatureCollection") do
      collection = FeatureCollection.new [] of Feature

      collection.type.should eq "FeatureCollection"
    end
  end

  describe "#to_json" do
    it "returns accurate json" do
      collection = FeatureCollection.new [Feature.new(Point.new(1, 0)), Feature.new(Point.new(1, 0))]

      collection.to_json.should eq %({"type":"FeatureCollection","features":[\
        {"type":"Feature","geometry":{"type":"Point","coordinates":[1.0,0.0]},"properties":null},\
        {"type":"Feature","geometry":{"type":"Point","coordinates":[1.0,0.0]},"properties":null}]})
    end
  end

  describe "#from_json" do
    it "creates a FeatureCollection from the matching json" do
      result = FeatureCollection.from_json %({"type":"FeatureCollection","features":[\
        {"type":"Feature","geometry":{"type":"Point","coordinates":[1.0,0.0]},"properties":null},\
        {"type":"Feature","geometry":{"type":"Point","coordinates":[1.0,0.0]},"properties":null}]})

      reference = FeatureCollection.new [Feature.new(Point.new(1, 0)), Feature.new(Point.new(1, 0))]

      result.should eq reference
    end
  end
end
