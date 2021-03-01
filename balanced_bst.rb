sorted_array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
unsorted_array = [14,13,12,11,10,9,8,7,6,5,4,3,2,1]

class Node
  include Comparable
  def <=>(other)
    data <=> other.data
  end
  attr_reader :data
  attr_accessor :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_reader :root

  def initialize(array)
    @root = make_tree(array)
  end

  def make_tree(array)
    sorted = my_merge(array)
    build_tree(sorted)
  end

  def my_merge(array)
    return array if array.length == 1
    halves = []
    if array.length.even?
      array.each_slice(array.length/2) do |half|
        halves << half
      end
    else
      array.each_slice(array.length/2+1) do |half|
        halves << half
      end
    end
    sequence = [my_merge(halves[0]), my_merge(halves[1])]

    return sort_halves(sequence[0], sequence[1])
  end

  def sort_halves(left, right)
    sorted = []
    until left.empty? || right.empty?
      until right.empty?
        if left[0] >= right[0]
          sorted << right.shift
        else
          sorted << left.shift
          break
        end
      end
    end

    unless left.empty?
      left.each do |e|
        sorted << e
      end
    end
    unless right.empty?
      right.each do |e|
        sorted << e
      end
    end
    sorted
  end

  def build_tree(arr, start=0, fini=arr.length-1)
    return nil if start > fini

    mid = (start+fini)/2
    ground = Node.new(arr[mid])
    ground.left = build_tree(arr, start, mid-1)
    ground.right = build_tree(arr, mid+1, fini)
    return ground
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

a = Tree.new(sorted_array)
a.pretty_print
5.times do
  puts "\n"
end
b = Tree.new(unsorted_array)
b.pretty_print
