module GeoJSON
  # TODO
  abstract class CoordinateTree
    # TODO
    class Root < CoordinateTree
      getter children = [] of CoordinateTree

      # TODO
      def self.new(parser : JSON::PullParser)
        root = self.new()

        parser.read_begin_array
        while parser.kind != :end_array
          if parser.kind == :begin_array
            Branch.new root, parser
          elsif parser.kind == :int || parser.kind == :float
            Leaf.new root, parser
          else
            # TODO: raise some sort of error
          end
        end
        parser.read_end_array

        root
      end

      def parent
        raise "Roots do not have parents!"
      end

      def leaf_value
        raise "Roots do not have leaf values!"
      end

      def_equals_and_hash children
    end

    # TODO
    class Branch < CoordinateTree
      getter children = [] of CoordinateTree
      property parent : CoordinateTree

      # TODO
      def initialize(@parent : CoordinateTree)
        parent.add_child self
      end

      # TODO
      def self.new(parent : CoordinateTree, parser : JSON::PullParser)
        branch = new(parent)

        parser.read_begin_array
        while parser.kind != :end_array
          if parser.kind == :begin_array
            Branch.new branch, parser
          elsif parser.kind == :int || parser.kind == :float
            Leaf.new branch, parser
          else
            # TODO: raise some sort of error
          end
        end
        parser.read_end_array

        branch
      end

      def leaf_value
        raise "Branches do not have leaf values!"
      end

      def_equals_and_hash children
    end

    # TODO
    class Leaf < CoordinateTree
      property parent : CoordinateTree
      property leaf_value : Float64

      # TODO
      def initialize(@parent : CoordinateTree, leaf_value : Number)
        @leaf_value = leaf_value.to_f64
        parent.add_child self
      end

      # TODO
      def self.new(parent : CoordinateTree, parser : JSON::PullParser)
        new(parent, parser.read_float)
      end

      def children
        raise "Leaves do not have children!"
      end

      def_equals_and_hash leaf_value
    end

    # TODO
    abstract def leaf_value : Float32

    # TODO
    abstract def parent : CoordinateTree

    # TODO
    abstract def children : Array(CoordinateTree)

    # :nodoc:
    protected def add_child(child : CoordinateTree)
      children << child
    end

    # TODO
    def CoordinateTree.new(parser : JSON::PullParser)
      Root.new parser
    end
  end
end
