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
  attr_accessor :queue, :sequence, :root

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

  def level_order(array=[], cue=queue)
    if cue.empty?
      cue << root
      return array
    end
    temp = cue.shift
    array << temp.data
    cue << temp.left if temp.left
    cue << temp.right if temp.right
    level_order(array, cue)
  end

  def postorder(node=root, array=[])
    array << postorder(node.left) if node.left
    array << postorder(node.right) if node.right
    array << node.data
    return array.flatten
  end

  def preorder(node=root, array=[])
    temp_left = []
    temp_right = []
    temp_left << preorder(node.left) if node.left
    temp_right << preorder(node.right) if node.right
    array << node.data
    array << temp_left
    array << temp_right
    return array.flatten
  end

  def inorder(node=root, array=[])
    temp_left = []
    temp_right = []
    temp_left << inorder(node.left) if node.left
    temp_right << inorder(node.right) if node.right
    array << temp_left
    array << node.data
    array << temp_right
    return array.flatten
  end

  def height(node)
    start = find(node)
    get_height(start)
  end

  def get_height(node, count=0)
    le = get_height(node.left, count+1) if node.left
    ri = get_height(node.right, count+1) if node.right
    if le && ri
      if le >= ri
        count = le
      else
        count = ri
      end
    elsif le || ri
      if le
        count = le
      elsif ri
        count = ri
      end
    end
    return count
  end

  def balanced?(node=root)
    if node.left
      return false unless balanced?(node.left)
    end
    if node.right
      return false unless balanced?(node.right)
    end
    node_balanced?(node)
  end

  def node_balanced?(node=root)
    a = get_height(node.left) if node.left
    b = get_height(node.right) if node.right
    a = 0 if !a
    b = 0 if !b
    return true if (a-b) < 2 && (a-b) > -2
  end

  def rebalance
    return if self.balanced?
    array = self.level_order
    self.root = make_tree(array)
  end

  def depth(val, node=root, count=0)
    return count if val == node.data

    if val < node.data
      if node.left == nil
        puts "\nKey not found.\n"
        return nil
      else
        depth(val, node.left, count+1)
      end
    elsif val > node.data
      if node.right == nil
        puts "\nKey not found.\n"
        return nil
      else
        depth(val, node.right, count+1)
      end
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

2.times do
  puts "\n"
end
p c.postorder

2.times do
  puts "\n"
end
p c.preorder

2.times do
  puts "\n"
end
p c.inorder

5.times do
  puts "\n"
end
c.pretty_print
p c.height("t")
p c.depth("z")
p c.balanced?
c.insert("23")
c.insert("24")
c.insert("25")
c.pretty_print
p c.balanced?
c.rebalance
c.pretty_print
p c.balanced?

rand_arr = Array.new(15) { rand(1..100) }
d = Tree.new(rand_arr)
d.pretty_print
p d.balanced?
p d.level_order
p d.preorder
p d.inorder
p d.postorder
d.insert(113)
d.insert(114)
d.insert(117)
d.insert(118)
d.insert(109)
d.insert(111)
d.pretty_print
p d.balanced?
d.rebalance
d.pretty_print
p d.balanced?
