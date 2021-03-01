sorted_array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]

class Node
  include Comparable
  def <=>(other)
    data <=> other.data
  end
  attr_reader :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
end
