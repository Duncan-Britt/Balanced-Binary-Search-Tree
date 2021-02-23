sorted_array = [1,2,3,4,6,7,8]

class Node
  attr_reader :data
  attr_accessor :left, :right

  def initialize(value)
    @data = value
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root

  def initialize(data)
    @root = build_tree(data)
  end

  def build_tree(data)
    return nil if 0 > data.length-1
    if data.length == 1
      return Node.new(data[0])
    end
    mid = data.length/2

    root = Node.new(data[mid])
    data[0..mid-1]
    root.left = build_tree(data[0..mid-1])
    root.right = build_tree(data[mid+1..-1])
    return root
  end

  def insert(root, key)
    if root == nil
      return Node.new(key)
    else
      if root.data == key
        return root
      elsif root.data < key
        root.right = insert(root.right, key)
      else
        root.left = insert(root.left, key)
      end
    end
    return root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

a = Tree.new(sorted_array)
a.pretty_print
a.insert(a.root, 5)
a.pretty_print

# spacer
