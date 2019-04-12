require "spec"
require "../src/geojson/**"

include GeoJSON

struct EquivalentJSONExpectation(T)
  def initialize(@expected_value : T)
  end

  def match(actual_value)
    JSON.parse(actual_value) == JSON.parse(@expected_value)
  end

  def failure_message(actual_value)
    <<-FAILURE
    Expected: #{@expected_value}
         got: #{actual_value}
    FAILURE
  end

  def negative_failure_message(actual_value)
    <<-FAILURE
    Expected: actual_value != #{@expected_value}
         got: #{actual_value}
    FAILURE
  end
end

def be_equivalent_json_to(expected)
  EquivalentJSONExpectation.new expected
end

alias Root = CoordinateTree::Root
alias Branch = CoordinateTree::Branch
alias Leaf = CoordinateTree::Leaf

class CoordinateTree::Root
  def cloned_children
    map { |child| child }
  end
end

class CoordinateTree::Branch
  def cloned_children
    map { |child| child }
  end
end
