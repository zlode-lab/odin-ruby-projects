class Node
    public

    attr_accessor :value, :next_node

    def initialize(value, next_node = nil)
        @value = value
        @next_node = next_node
    end
end
class LinkedList
    public

    attr_reader :head, :tail, :size

    private

    attr_writer :head, :tail, :size

    def initialize(head = nil)
        @head = head
        unless (head.nil?)
            curr = head
            size = 1
            until (curr.next_node.nil?)
                size += 1
                curr = curr.next_node
            end
            tail = curr
        end
        @size = size ? size : 0
        @tail = tail ? tail : nil
    end

    public

    def append(val)
        if (self.size == 0)
            self.head = Node.new(val)
            self.tail = head
            self.size += 1
            return
        end
        self.tail.next_node = Node.new(val)
        self.tail = self.tail.next_node
        self.size += 1
    end

    def prepend(val)
        if (self.size == 0)
            self.head = Node.new(val)
            self.tail = self.head
            self.size += 1
            return
        end
        self.head = Node.new(val, self.head)
        self.size += 1
    end

    def at(index)
        return -1 if (index < 0 || index >= self.size)
        curr = self.head
        i = 0
        until (i == index)
            i += 1
            curr = curr.next_node
        end
        curr
    end

    def pop()
        return -1 if self.size == 0
        if (self.size == 1)
            self.head = nil
            self.tail = nil
            self.size -= 1
            return 
        end
        curr = self.head
        until (curr.next_node == self.tail)
            curr = curr.next_node
        end
        self.tail = curr
        curr.next_node = nil
        self.size -= 1
    end

    def contains?(val)
        curr = self.head
        until (curr == nil)
            return true if curr.value == val
            curr = curr.next_node
        end
        false
    end

    def find(val)
        curr = self.head
        index = 0
        until (curr == nil)
            return index if curr.value == val
            curr = curr.next_node
            index += 1
        end
        nil
    end

    def to_s
        curr = self.head
        string = ''
        until (curr == nil)
            string += "( #{curr.value.to_s} )" + ' -> '
            curr = curr.next_node
        end
        string + 'nil'
    end

    def insert_at(val, index)
        return -1 if (index < 0 || index > self.size)
        return prepend(val) if index == 0
        previous = at(index-1)
        previous.next_node = Node.new(val, previous.next_node)
        self.size += 1
    end

    def remove_at(index)
        return -1 if (index < 0 || index >= self.size)
        self.size -= 1
        if (index == 0)
            if (size == 1) 
                self.head = nil
                self.tail = nil
            else
                self.head = self.head.next_node
            end
            return
        end
        previous = at(index-1)
        previous.next_node = previous.next_node.next_node
    end

end