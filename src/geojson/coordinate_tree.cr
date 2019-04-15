module GeoJSON
  # A `CoordinateTree` is a standard tree structure in which there is a defined,
  # parent-less `Root`, intermediate `Branch` nodes, and `Leaf` nodes which have
  # floating-point values and lack children.
  abstract class CoordinateTree
    # A `CoordinateTree::Root` is the root node of a `CoordinateTree` structure.
    # It has children but no parent or leaf value.
    class Root < CoordinateTree
      private getter children = [] of CoordinateTree

      # Creates a `CoordinateTree` from the given `JSON::PullParser`. This
      # constructor assumes that the *parser* is positioned at the beginning of
      # a GeoJSON coordinate string.
      def self.new(parser : JSON::PullParser)
        root = self.new

        parser.read_begin_array
        while parser.kind != :end_array
          if parser.kind == :begin_array
            Branch.new root, parser
          elsif parser.kind == :int || parser.kind == :float
            Leaf.new root, parser
          else
            raise MalformedCoordinateException.new "Cannot parse into CoordinateTree!"
          end
        end
        parser.read_end_array

        root
      end

      # Raises an exception because a Root does not have a leaf value.
      def leaf_value
        raise "Roots do not have leaf values!"
      end

      # Iterates over this Root's children.
      delegate "each", to: children

      def_equals_and_hash @children
    end

    # A `CoordinateTree::Branch` is an intermediate node in a `CoordinateTree`
    # structure. It has children and a parent but no leaf value.
    class Branch < CoordinateTree
      private getter children = [] of CoordinateTree

      # Creates a new `Branch` with the given *parent* and adds the new `Branch`
      # as a child of *parent*.
      def initialize(parent : CoordinateTree)
        parent.add_child self
      end

      # Creates a new `Branch` as a child of *parent* based on *parser*. This
      # constructor assumes that the *parser* is positioned at the beginning of
      # an array in a GeoJSON coordinate string.
      def self.new(parent : CoordinateTree, parser : JSON::PullParser)
        branch = new(parent)

        parser.read_begin_array
        while parser.kind != :end_array
          if parser.kind == :begin_array
            Branch.new branch, parser
          elsif parser.kind == :int || parser.kind == :float
            Leaf.new branch, parser
          else
            raise MalformedCoordinateException.new "Cannot parse into CoordinateTree!"
          end
        end
        parser.read_end_array

        branch
      end

      # Raises an exception because a Branch does not have a leaf value.
      def leaf_value
        raise "Branches do not have leaf values!"
      end

      # Iterates over this Branch's children.
      delegate "each", to: children

      def_equals_and_hash @children
    end

    # A `CoordinateTree::Leaf` is a terminal node in a `CoordinateTree`
    # structure. It has a parent and a leaf value but no children.
    class Leaf < CoordinateTree
      # The Float64 value at this Leaf
      property leaf_value : Float64

      # Creates a new `Leaf` with the given *parent* and *leaf_value* and adds
      # the new `Branch` as a child of *parent*.
      def initialize(parent : CoordinateTree, leaf_value : Number)
        @leaf_value = leaf_value.to_f64
        parent.add_child self
      end

      # Creates a new `Leaf` as a child of *parent* based on *parser*. This
      # constructor assumes that the *parser* is positioned at the beginning of
      # a position array in a GeoJSON coordinate string.
      def self.new(parent : CoordinateTree, parser : JSON::PullParser)
        new(parent, parser.read_float)
      end

      # Raises an exception because a Leaf has no children to enumerate upon.
      def each(&block)
        raise "Leaves have no children to enumerate!"
      end

      def_equals_and_hash leaf_value
    end

    include Enumerable(CoordinateTree)

    # Gets the leaf value of this `CoordinateTree` node.
    #
    # `CoordinateTree::Root` and `CoordinateTree::Branch` nodes will raise when
    # this method is called.
    abstract def leaf_value : Float32

    # :nodoc:
    # Adds the given `CoordinateTree` node as a *child* of this node.
    protected def add_child(child : CoordinateTree)
      children << child
    end

    # Creates a new `CoordinateTree` structure based on the given *parser*.
    def CoordinateTree.new(parser : JSON::PullParser)
      Root.new parser
    end
  end
end
