raise IndexError if index.negative? || index >= @buckets.length
class HashMapNode
  private

  attr_accessor :key, :value, :next_node

  def initialize(key, value, next_node = nil)
      @key = key
      @value = value
      @next_node = next_node
  end
end

class HashMap

  private

  def initialize()
    @load_factor
    @capacity
  end

  def hash(key)
    hash_code = 0
   prime_number = 31
      
   key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
      
   hash_code
  end

  def set(key, value)
    assign to bucket
    resolve colllision?

  end

  def get(key)
    val : nil
  end

  def has?(key)
    true : false
  end

  def remove(key)
    value : nil
  end

  def length
  end

  def clear
    remove all
  end

  def keys
    all keys
  end

  def values
    all values
  end

  def entries
    arr[[key1, val1], ...]
  end



end
