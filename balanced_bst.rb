array1 = [20,30,40,32,34,36,50,70,60,65,80,75,85]
array2 = ["j", "a", "c", "k", "d", "a", "w", "s", "l", "o", "v", "e", "m", "y", "b", "i", "g", "s", "p", "h", "i", "i", "n", "x", "o", "f", "q", "u", "a", "r", "t", "z"]

class Node
  attr_accessor :data
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
    build_tree(sorted.uniq)
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

  def insert(val, node=root)
    if val < node.data
      if node.left == nil
        node.left = Node.new(val)
      else
        insert(val, node.left)
      end
    else
      if node.right == nil
        node.right = Node.new(val)
      else
        insert(val, node.right)
      end
    end
  end

  def delete(val, node=root, stck=[node])
    case
    when node.left && node.right
      puts "path1"
      check_value(val, node, stck)
    when node.right || node.left && !(node.left && node.right)
      puts "path2"
      if node.left
        check_value(val, node, stck)
      else
        check_value(val, node, stck)
      end
    else
      puts "path3"
      if stck[-1].right
        if stck[-1].right.data == val
          stck[-1].right = nil
        end
      elsif stck[-1].left
        if stck[-1].left.data == val
          stck[-1].left = nil
        end
      end
    end
  end

  def check_value(val, node, stck)
    if val < node.data
      stck << node
      delete(val, node.left, stck)
    elsif val == node.data
      node.data = least(node)
    else
      stck << node
      delete(val, node.right, stck)
    end
  end

  def least(node, stack=[], rightt=true)
    if stack.length == 0 && node.right
      stack << node
      least(node.right, stack)
    elsif stack.length == 0
      stack << node
      rightt = false
      least(node.left, stack, rightt)
    elsif !node.left && stack.length == 1
      if rightt
        stack[-1].right=nil
      else
        stack[-1].left = nil
      end
      return node.data
    elsif !node.left
      stack[-1].left=nil
      return node.data
    else
      stack << node
      least(node.left, stack)
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

a = Tree.new(array1)
a.pretty_print
5.times do
  puts "\n"
end
b = Tree.new(array2)
b.pretty_print
5.times do
  puts "\n"
end
a.insert(33)
a.pretty_print
5.times do
  puts "\n"
end
a.delete(75)
a.pretty_print
