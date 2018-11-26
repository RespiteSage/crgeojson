require "./spec_helper"

describe Position do
  describe ".new" do
    it "properly sets the longitude and latitude" do
      result = Position.new 15.0, 10.0

      result.lon.should eq 15.0
      result.lat.should eq 10.0
    end

    it "accepts integers" do
      result = Position.new 15, 10

      result.lon.should eq 15.0
      result.lat.should eq 10.0
    end
  end

  describe "#from_json" do
    it "returns a Position corresponding to the json" do
      position = Position.from_json "[10.0,15.0]"
      reference = Position.new 10.0, 15.0

      position.should eq reference
    end
  end

  describe "#to_json" do
    it "returns accurate geoJSON" do
      position = Position.new 10.0, 15.0

      position.to_json.should eq "[10.0,15.0]"
    end
  end
end
