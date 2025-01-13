#raise IndexError if index.negative? || index >= @buckets.length

class HashMapNode
  public

  attr_accessor :key, :value, :next_node

  def initialize(key, value, next_node = nil)
      @key = key
      @value = value
      @next_node = next_node
  end
end

class HashMap

  public

  attr_reader :length

  protected

  attr_reader :load_factor
  attr_writer :length
  attr_accessor :buckets, :capacity

  def initialize(capacity = 16)
    @buckets = Array.new(capacity)
    @load_factor = 0.75
    @length = 0
    @capacity = capacity
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
      
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
      
    hash_code
  end

  def increase_buckets()
    self.capacity *= 2
    temp = HashMap.new(self.capacity)
    self.entries.each {|node|
      temp.set(node[0], node[1])
    }
    self.buckets = temp.buckets
  end

  public

  def set(key, value)
    hash = self.hash(key) % self.capacity
    if self.buckets[hash].nil?
      self.buckets[hash] = HashMapNode.new(key, value) 
    else
      prev_node = self.buckets[hash]
      node = self.buckets[hash]
      until node.nil?
        if node.key == key
          node.value = value
          return
        end
        node = node.next_node
      end
      prev_node.next_node = HashMapNode.new(key, value) 
    end

    self.length += 1
    if self.length / self.capacity.to_f > self.load_factor
      self.increase_buckets()
    end
  end

  def get(key)
    hash = self.hash(key) % self.capacity
    if self.buckets[hash].nil?
      return nil 
    else
      node = self.buckets[hash]
      until node == nil
        if node.key == key
          return node.value
        end
        node = node.next_node
      end
      return nil
    end
  end

  def has?(key)
    hash = self.hash(key) % self.capacity
    if self.buckets[hash].nil?
      return false 
    else
      node = self.buckets[hash]
      until node == nil
        if node.key == key
          return true
        end
        node = node.next_node
      end
      return false
    end
  end

  def remove(key)
    hash = self.hash(key) % self.capacity
    if self.buckets[hash].nil?
      return nil 
    else
      prev_node = self.buckets[hash]
      node = self.buckets[hash]
      if (node.next_node.nil?)
        self.buckets[hash] = nil
        self.length -= 1
        return node.value
      end
      until node == nil
        if node.key == key
          prev_node.next_node = node.next_node
          self.length -= 1
          return node.value
        end
        prev_node = node
        node = node.next_node
      end
      return nil
    end
  end

  def clear
    self.buckets = Array.new(16)
    self.length = 0
  end

  def keys
    arr = []
    self.buckets.each do |bucket|
      node = bucket
      until node.nil?
        arr.push(node.key)
        node = node.next_node
      end
    end
    arr
  end

  def values
    arr = []
    self.buckets.each do |bucket|
      node = bucket
      until node.nil?
        arr.push(node.value)
        node = node.next_node
      end
    end
    arr
  end

  def entries
    arr = []
    self.buckets.each do |bucket|
      node = bucket
      until node.nil?
        arr.push([node.key, node.value])
        node = node.next_node
      end
    end
    arr
  end

end
