module GeoJSON
  abstract class CoordinateTree
    class Root < CoordinateTree
      #TODO
    end


    class Branch < CoordinateTree
      #TODO
    end


    class Leaf < CoordinateTree
      #TODO
    end
  end


  abstract def leaf_value : Float

  abstract def parent : CoordinateTree

  abstract def children : Array(CoordinateTree)

  private def addChild(CoordinateTree child)
    children << child
  end

  def self.from_geojson(parser : JSON::PullParser)
    # TODO
  end

  private def self.from_geojson(parser : JSON::PullParser, parent : CoordinateTree)
    # TODO
  end

end
