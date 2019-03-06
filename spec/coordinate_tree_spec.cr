require "./spec_helper"

describe CoordinateTree do
  describe Root do
    describe ".new" do
      it "creates a Root without children" do
        # TODO
      end
    end

    describe "#leaf_value" do
      it "throws an error" do
        # TODO
      end
    end

    describe "#parent" do
      it "throws an error" do
        # TODO
      end
    end

    describe "#children" do
      it "returns the children given in the constructor" do
        # TODO
      end
    end
  end

  describe Branch do
    describe ".new" do
      it "creates a Branch with the given parent and without children" do
        # TODO
      end

      it "adds the Branch to its parent" do
        # TODO
      end
    end

    describe "#leaf_value" do
      it "throws an error" do
        # TODO
      end
    end

    describe "#parent" do
      it "returns the parent of the Branch" do
        # TODO
      end
    end

    describe "#children" do
      it "returns the children given in the constructor" do
        # TODO
      end
    end
  end

  describe Leaf do
    describe ".new" do
      it "creates a Leaf with the given parent and leaf value" do
        # TODO
      end

      it "adds the Leaf to its parent" do
        # TODO
      end
    end

    describe "#leaf_value" do
      it "returns 3 when given in the constructor" do
        # TODO
      end
    end

    describe "#parent" do
      it "returns the parent of the Leaf" do
        # TODO
      end
    end

    describe "#children" do
      it "throws an error" do
        # TODO
      end
    end
  end

  describe ".from_geojson" do
    it "deserializes just a root" do
      # TODO
    end

    it "deserializes a root with leaves" do
      # TODO
    end

    it "deserializes a root with a single branch" do
      # TODO
    end

    it "deserializes a root with multiple branches" do
      # TODO
    end

    it "deserializes a root with branches and leaves" do
      # TODO
    end
  end
end
