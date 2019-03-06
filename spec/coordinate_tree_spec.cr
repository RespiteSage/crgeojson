require "./spec_helper"

alias Root = CoordinateTree::Root
alias Branch = CoordinateTree::Branch
alias Leaf = CoordinateTree::Leaf

describe CoordinateTree do
  describe "::Root" do
    describe ".new" do
      it "creates a Root without children" do
        root = Root.new

        root.children.should eq [] of CoordinateTree
      end
    end

    describe "#leaf_value" do
      it "throws an error" do
        expect_raises(Exception, "Roots do not have leaf values!") do
          Root.new.leaf_value
        end
      end
    end

    describe "#parent" do
      it "throws an error" do
        expect_raises(Exception, "Roots do not have parents!") do
          Root.new.parent
        end
      end
    end

    describe "#children" do
      it "returns the children added to the Root" do
        root = Root.new
        branch = Branch.new root
        leaf = Leaf.new root, 3

        root.children.should eq [branch, leaf]
      end
    end
  end

  describe "::Branch" do
    describe ".new" do
      it "creates a Branch with the given parent and without children" do
        parent = Root.new
        branch = Branch.new parent

        branch.parent.should be parent
        branch.children.should eq [] of CoordinateTree
      end

      it "adds the Branch to its parent" do
        parent = Root.new
        branch = Branch.new parent

        parent.children.should eq [branch]
      end
    end

    describe "#leaf_value" do
      it "throws an error" do
        expect_raises(Exception, "Branches do not have leaf values!") do
          Branch.new(Root.new).leaf_value
        end
      end
    end

    describe "#parent" do
      it "returns the parent of the Branch" do # is this unnecessary repetition?
        parent = Root.new
        branch = Branch.new parent

        branch.parent.should be parent
      end
    end

    describe "#children" do
      it "returns the children added to the Branch" do
        parent = Root.new
        big_branch = Branch.new parent
        lil_branch = Branch.new big_branch
        leaf = Leaf.new big_branch, 5

        big_branch.children.should eq [lil_branch, leaf]
      end
    end
  end

  describe "::Leaf" do
    describe ".new" do
      it "creates a Leaf with the given parent and leaf value" do
        parent = Root.new
        leaf = Leaf.new parent, 7.0

        leaf.parent.should be parent
        leaf.leaf_value.should eq 7.0
      end

      it "adds the Leaf to its parent" do
        parent = Root.new
        leaf = Leaf.new parent, 11.0

        parent.children.should eq [leaf]
      end
    end

    describe "#leaf_value" do
      it "returns 3 when given in the constructor" do # is this unnecessary repetition?
        leaf = Leaf.new Root.new, 13.0

        leaf.leaf_value.should eq 13.0
      end
    end

    describe "#parent" do
      it "returns the parent of the Leaf" do # is this unnecessary repetition?
        parent = Root.new
        leaf = Leaf.new parent, 17

        leaf.parent.should be parent
      end
    end

    describe "#children" do
      it "throws an error" do
        expect_raises(Exception, "Leaves do not have children!") do
          Leaf.new(Root.new, 19.0).children
        end
      end
    end
  end

  describe ".from_geojson" do
    it "deserializes just a root" do
      tree = CoordinateTree.from_geojson(JSON::PullParser.new "[]")

      tree.should eq Root.new
    end

    it "deserializes a root with leaves" do
      tree = CoordinateTree.from_geojson(JSON::PullParser.new "[23, 29]")

      root = Root.new
      leaf1 = Leaf.new root, 23
      leaf2 = Leaf.new root, 29

      tree.should eq root
    end

    it "deserializes a root with a single branch" do
      tree = CoordinateTree.from_geojson(JSON::PullParser.new "[[]]")

      root = Root.new
      branch = Branch.new root

      tree.should eq root
    end

    it "deserializes a root with multiple branches" do
      tree = CoordinateTree.from_geojson(JSON::PullParser.new "[[], []]")

      root = Root.new
      branch1 = Branch.new root
      branch2 = Branch.new root

      tree.should eq root
    end

    it "deserializes a root with branches and leaves" do
      tree = CoordinateTree.from_geojson(JSON::PullParser.new "[[31, 37], [41, 43]]")

      root = Root.new
      branch1 = Branch.new root
      leaf11 = Leaf.new branch1, 31
      leaf12 = Leaf.new branch1, 37
      branch2 = Branch.new root
      leaf21 = Leaf.new branch2, 41
      leaf22 = Leaf.new branch2, 43

      tree.should eq root
    end
  end
end
