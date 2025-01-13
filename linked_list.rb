class Node
    public
    def initialize(value, next_node)
        value: value
        next_node: next_node
    end
end
class LinkedList

    attr_reader :head, :tail :size

    private

    def initialize(head)
        @head = head
        @size = find_size(head)
        @tail
    end

    def find_size(head)
      curr = head
      size = 0
      until (curr.nil?)
        size += 1
        curr = curr.next
      end
      size
    end

    public

    def at(index)
        curr = self.head
        i = 0
        until (i == index)
            i += 1
            curr = curr.next
        end
        curr
    end

    def pop()
        curr = self.head
        until (curr.next == self.tail)
            curr = curr.next
        end
        self.tail = curr
        curr.next = nil
    end

    def contains?(val)
        curr = self.head
        until (curr == nil)
            return true if curr.value == val
            curr = curr.next
        end
        false
    end

    def find(val)
        curr = self.head
        index = 0
        until (curr == nil)
            return index if curr.value == val
            curr = curr.next
            index += 1
        end
        nil
    end

    def to_s
        curr = self.head
        string = ''
        until (curr == nil)
            string += "( #{curr.val.to_s} )" + ' -> '
            curr = curr.next
        end
        print string + 'nil'
    end

    def insert_at(val, index)
        previous = at(index-1)
        previous.next = Node.new(val, previous.next)
    end

    def remove_at(index)
        previous = at(index-1)
        previous.next = previous.next.next
    end

end