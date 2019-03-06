module GeoJSON
  # TODO
  abstract class CoordinateTree
    # TODO
    class Root < CoordinateTree
      getter children = [] of CoordinateTree

      def parent
        raise "Roots do not have parents!"
      end

      def leaf_value
        raise "Roots do not have leaf values!"
      end

      def_equals_and_hash children
    end


    class Branch < CoordinateTree
      getter children = [] of CoordinateTree
      property parent : CoordinateTree

      # TODO
      def initialize(@parent : CoordinateTree)
        parent.add_child self
      end

      def leaf_value
        raise "Branches do not have leaf values!"
      end

      def_equals_and_hash parent, children
    end


    class Leaf < CoordinateTree
      property parent : CoordinateTree
      property leaf_value : Float32

      # TODO
      def initialize(@parent : CoordinateTree, leaf_value : Number)
        @leaf_value = leaf_value.to_f32
        parent.add_child self
      end

      def children
        raise "Leaves do not have children!"
      end

      def_equals_and_hash parent, leaf_value
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
    def CoordinateTree.from_geojson(parser : JSON::PullParser)
      # TODO
    end

    # :nodoc:
    private def CoordinateTree.from_geojson(parser : JSON::PullParser, parent : CoordinateTree)
      # TODO
    end
  end
end
