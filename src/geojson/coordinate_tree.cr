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


  abstract def leafValue : Float

  abstract def parent : CoordinateTree

  abstract def children : Array(CoordinateTree)

  private def addChild(CoordinateTree child)
    children << child
  end

  def fromGeoJSON(parser : JSON::PullParser)
    # TODO
  end

  private def fromGeoJSON(parser : JSON::PullParser, parent : CoordinateTree)
    # TODO
  end

end
