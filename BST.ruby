class Node
  attr_accessor :value, :left_node, :right_node
  def initialize(value = 0, left_node = nil, right_node = nil)
    @value = value
    @left_node = left_node
    @right_node = right_node
  end
end
class Tree
  private
  def initialize(array = [])
    @root = build_tree(array)
  end

  def build_tree(array)
    array.sort
    array.unique
    root = array[array.length / 2]




    root
  end

  public

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
  
  def insert(value)
  end

  def delete(value)
  end

  def find(value)
  end

  def level_order()
    bfs yield
    iter/recurs
    if no block
      return arr
  end

  def inorder
    yield
    if no block
      return arr
  end

  def preorder
    yield
    if no block
      return arr
  end

  def postorder
    yield
    if no block
      return arr
  end

  def height(node)
    node to deepest lead node
  end

  def depth(node)
    root to node
  end

  def balanced?
    true false
  end

  def rebalance
    make arr and build_tree()
  end

end
arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
