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
  attr_accessor :queue

  def initialize(array)
    @root = make_tree(array)
    @queue = [@root]
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

  def min_value_node(node)
    # base case
    return node unless node.left
    # loop down to find the leftmost leaf
    min_value_node(node.left)
  end

  def delete(val, node=root)
    # Base Case
    return node unless node

    # value is less than root, must be in left subtree
    if val < node.data
      node.left = delete(val, node.left)
    # if val greater than root, must be in right subtree
    elsif val > node.data
      node.right = delete(val, node.right)
    # if val is same as root value, this is the node to be deleted
    else
      # node with one or no children
      if node.left == nil
        temp = node.right
        node = nil
        return temp
      elsif node.right == nil
        temp = node.left
        node = nil
        return temp
      end

      # Node with two children:
      # Get the inorder successor
      # (smallest in the right subtree)
      temp = min_value_node(node.right) # MAKE THIS METHOD !!!!
      # copy the inorder successor's content to this node
      node.data = temp.data
      # delete the inorder successor
      node.right = delete(temp.data, node.right) # why the assignment !!!!!
    end

    return node
  end

  def find(val, node=root)
    return node if val == node.data

    if val < node.data
      if node.left == nil
        puts "\nKey not found.\n"
        return nil
      else
        find(val, node.left)
      end
    elsif val > node.data
      if node.right == nil
        puts "\nKey not found.\n"
        return nil
      else
        find(val, node.right)
      end
    end
  end

  def level_order(array=[])
    return array if queue.empty?
    temp = queue.shift
    array << temp.data
    queue << temp.left if temp.left
    queue << temp.right if temp.right
    level_order(array)
    #array
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

a.insert(33)
a.pretty_print
5.times do
  puts "\n"
end
a.delete(50)
a.pretty_print

5.times do
  puts "\n"
end
b = Tree.new(array2)
b.pretty_print

5.times do
  puts "\n"
end
b.delete("p")
b.pretty_print

5.times do
  puts "\n"
end
c = Tree.new(array2)
c.pretty_print
p c.find("w")

5.times do
  puts "\n"
end
c.pretty_print
p c.level_order
