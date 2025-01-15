class Node
  attr_accessor :value, :left_node, :right_node
  def initialize(value = 0, left_node = nil, right_node = nil)
    @value = value
    @left_node = left_node
    @right_node = right_node
  end
end
class Tree
  attr_reader :root
  private
  def initialize(array = [])
    p array
    @root = build_tree(array)
  end

  def build_tree(arr)
    arr = arr.uniq.sort
    root = Node.new(arr[arr.length / 2])
    queue = [{node: root, range: [0, (arr.length - 1)]}]
    index = 0
    while (index < queue.size)
      mid = queue[index]
      s = mid[:range][0]
      e = mid[:range][1]
      middle_index = s + (e - s) / 2
      if (s < middle_index)
        left_index = s + (middle_index - 1 - s) / 2
        mid[:node].left_node = Node.new(arr[left_index])
        queue.push({node: mid[:node].left_node, range: [s, middle_index-1]})
      end
      if (e > middle_index)
        right_index = middle_index + 1 + (e - middle_index - 1) / 2
        mid[:node].right_node = Node.new(arr[right_index])
        queue.push({node: mid[:node].right_node, range: [middle_index+1, e]})
      end
      index += 1
    end
    root
  end

  public

  def pretty_print(node = self.root, prefix = '', is_left = true)
    pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
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
  end

  def inorder
    yield
    if no block
      return arr
    end
  end

  def preorder
    yield
    if no block
      return arr
    end
  end

  def postorder
    yield
    if no block
      return arr
    end
  end

  def height(node)
    node to deepest lead node
  end

  def depth(node)
    root to node
  end

  def balanced?
    #true false
  end

  def rebalance
    make arr and build_tree()
  end

end
array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(array)
tree.pretty_print
