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
    @root = build_tree(array)
  end

  def build_tree(arr)
    arr = arr.uniq.sort
    root = Node.new(arr[(arr.length-1) / 2])
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
    curr = root
    while (curr)
      if (value > curr.value)
        if curr.right_node.nil?
          curr.right_node = Node.new(value)
          return
        end
        curr = curr.right_node
      elsif (value < curr.value)
        if curr.left_node.nil?
          curr.left_node = Node.new(value)
          return
        end
        curr = curr.left_node
      else 
        return
      end
    end
  end

  def delete(value)
    curr = root
    curr_parent = curr
    until (curr.nil?)
      if (curr.value == value)
        if (curr.left_node.nil? && curr.right_node.nil?)
          curr_parent.left_node = nil if curr_parent.left_node == curr
          curr_parent.right_node = nil if curr_parent.right_node == curr
          return
        elsif (!curr.left_node.nil? && !curr.right_node.nil?)
          node = curr.right_node
          if (node.left_node.nil?)
            node.left_node = curr.left_node
            curr_parent.left_node = node if curr_parent.left_node == curr
            curr_parent.right_node = node if curr_parent.right_node == curr
            return
          end
          node_parent = curr
          until (node.left_node.nil?)
            node_parent = node
            node = node.left_node
          end
          curr.value = node.value
          node_parent.left_node = node.right_node.nil? ? nil : node.right_node
          return
        elsif (curr.left_node.nil?)
          curr_parent.left_node = curr.right_node if curr_parent.left_node == curr
          curr_parent.right_node = curr.right_node if curr_parent.right_node == curr
          return
        elsif (curr.right_node.nil?)
          curr_parent.left_node = curr.left_node if curr_parent.left_node == curr
          curr_parent.right_node = curr.left_node if curr_parent.right_node == curr
          return
        end
      elsif (curr.value > value)
        curr_parent = curr
        curr = curr.left_node
      elsif (curr.value < value)
        curr_parent = curr
        curr = curr.right_node
      end
    end
  end

  def find(value)
    curr = root
    until (curr.nil?)
      if (curr.value == value)
        return curr
      elsif (curr.value > value)
        curr = curr.left_node
      elsif (curr.value < value)
        curr = curr.right_node
      end
    end
    nil
  end

  def level_order
    queue = [root]
    index = 0
    arr = []
    if block_given?
      block = lambda { |curr| yield(curr)}
    else
      block = lambda { |curr| arr.push(curr.value)}
    end
    until (index > queue.size-1)
      curr = queue[index]
      block.call(curr)
      queue.push(curr.left_node) unless curr.left_node.nil?
      queue.push(curr.right_node) unless curr.right_node.nil?
      index += 1
    end
    return arr unless arr.empty?
  end

  def level_order_recursive(queue = [root], &block)
    return if queue.empty?
    curr = queue.shift()
    queue.push(curr.left_node) unless curr.left_node.nil?
    queue.push(curr.right_node) unless curr.right_node.nil?
    if block_given?
      yield(curr)
      level_order_recursive(queue, &block)
    else
      val = level_order_recursive(queue)
      return [curr.value] + val unless val.nil?
      return [curr.value]
    end
  end

  def inorder(node = root, &block)
    return if node.nil?
    if block_given?
      inorder(node.left_node, &block)
      yield(node)
      inorder(node.right_node, &block)
    else
      val = []

      left_val = inorder(node.left_node)
      val += left_val unless left_val.nil?

      val += [node.value]

      right_val = inorder(node.right_node)
      val += right_val unless right_val.nil?

      return val
    end
  end

  def preorder(node = root, &block)
    return if node.nil?
    if block_given?
      yield(node)
      preorder(node.left_node, &block)
      preorder(node.right_node, &block)
    else
      val = [node.value]

      left_val = preorder(node.left_node)
      val += left_val unless left_val.nil?

      right_val = preorder(node.right_node)
      val += right_val unless right_val.nil?

      return val
    end
  end

  def postorder(node = root, &block)
    return if node.nil?
    if block_given?
      postorder(node.left_node, &block)
      postorder(node.right_node, &block)
      yield(node)
    else
      val = []

      left_val = postorder(node.left_node)
      val += left_val unless left_val.nil?

      right_val = postorder(node.right_node)
      val += right_val unless right_val.nil?

      val += [node.value]

      return val
    end
  end

  def height(node)
    queue = [node, "new level"]
    depth = 0
    index = 0
    until (index > queue.size-1)
      curr = queue[index]
      index += 1
      if curr == "new level"
        queue.push("new level")
        if (queue[index] == "new level")
          break;
        end
        depth += 1
        next
      end
      queue.push(curr.left_node) unless curr.left_node.nil?
      queue.push(curr.right_node) unless curr.right_node.nil?
    end
    depth
  end

  def depth(node)
    queue = [root, "new level"]
    depth = 0
    index = 0
    until (index > queue.size-1)
      curr = queue[index]
      index += 1
      if curr == "new level"
        queue.push("new level")
        if (queue[index] == "new level")
          break;
        end
        depth += 1
        next
      end
      if curr == node
        return depth
      end
      queue.push(curr.left_node) unless curr.left_node.nil?
      queue.push(curr.right_node) unless curr.right_node.nil?
    end
    return "node not found"
  end

  def balanced?
    stack = [root]
    until (stack.empty?)
      curr = stack.pop

      if curr.left_node.nil?
        left_height = 0
      else
        left_height = self.height(curr.left_node)+1
        stack.push(curr.left_node)
      end

      if curr.right_node.nil?
        right_height = 0
      else
        right_height = self.height(curr.right_node)+1
        stack.push(curr.right_node)
      end

      return false if (left_height - right_height).abs > 1
    end
    return true
  end

  def rebalance
    arr = self.inorder
    @root = build_tree(arr)
  end

end
array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(array)
tree.insert(25)
tree.pretty_print
p tree.balanced?
tree.rebalance
tree.pretty_print
p tree.balanced?
tree.insert(22)
tree.rebalance
tree.pretty_print
=begin
p tree.balanced?
tree.insert(0)
p tree.balanced?
tree.insert(25)
p tree.balanced?
tree.insert(4)
tree.insert(58)
tree.insert(0)
tree.insert(78)
tree.insert(22)
tree.insert(18)
tree.insert(19)
tree.insert(21)
tree.insert(20)
tree.insert(59)
tree.insert(9)
tree.pretty_print
tree.delete(10)
tree.delete(23)
tree.delete(18)
tree.delete(7)
tree.delete(58)
tree.pretty_print
p tree.find(58)
p tree.find(22)
p tree.level_order{ |val| p val.value}
p tree.level_order
puts "recursive"
p tree.level_order_recursive{ |val| p val.value}
p tree.level_order_recursive
p tree.preorder{ |val| p val.value}
p tree.inorder{ |val| p val.value}
p tree.postorder{ |val| p val.value}
p tree.preorder
p tree.inorder
p tree.postorder
tree.pretty_print
p tree.height(tree.find(19))
p tree.depth(tree.find(59))
p tree.balanced?
=end