require "./spec_helper"

describe FeatureCollection do
  describe ".new" do
    it "sets the feature array" do
      collection = FeatureCollection.new [Feature.new(Point.new [1, 0]), Feature.new(Point.new [0, 7])]

      collection.features[0].should eq Feature.new(Point.new [1, 0])
      collection.features[1].should eq Feature.new(Point.new [0, 7])
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
      feature = Feature.new(Point.new [1, 0])

      collection = FeatureCollection.new [feature, feature]

      reference_json = %({"type":"FeatureCollection","features":[#{feature.to_json},#{feature.to_json}]})

      collection.to_json.should be_equivalent_json_to reference_json
    end
  end

  describe "#from_json" do
    it "creates a FeatureCollection from the matching json" do
      feature = Feature.new(Point.new [1, 0])

      result = FeatureCollection.from_json %({"type":"FeatureCollection","features":[#{feature.to_json},#{feature.to_json}]})

      reference = FeatureCollection.new [Feature.new(Point.new [1, 0]), Feature.new(Point.new [1, 0])]

      result.should eq reference
    end
  end

  describe "#==" do
    first_feature = Feature.new Point.new([1, 0]), id: 47
    second_feature = Feature.new Point.new([0, 1])

    it "is true for the same object" do
      result = FeatureCollection.new [first_feature, second_feature]

      result.should eq result
    end

    it "is true for a different FeatureCollection with the same features" do
      first = FeatureCollection.new [first_feature, second_feature]

      second = FeatureCollection.new [first_feature, second_feature]

      first.should eq second
    end

    it "is false for a different FeatureCollection with different features" do
      first = FeatureCollection.new [first_feature, second_feature]

      second = FeatureCollection.new [second_feature]

      first.should_not eq second
    end

    it "is false for an object of another class" do
      first = FeatureCollection.new [first_feature, second_feature]

      second = "Something else"

      first.should_not eq second
    end
  end
end
