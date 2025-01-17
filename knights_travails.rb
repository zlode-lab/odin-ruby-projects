require 'set'
=begin
def printBoard(board, position)
    possible_moves_set = Set[
      {row: position[:row] + 2, column: position[:column] + 1},
      {row: position[:row] + 2, column: position[:column] - 1},
      {row: position[:row] - 2, column: position[:column] + 1},
      {row: position[:row] - 2, column: position[:column] - 1},
      {row: position[:row] + 1, column: position[:column] + 2},
      {row: position[:row] + 1, column: position[:column] - 2},
      {row: position[:row] - 1, column: position[:column] + 2},
      {row: position[:row] - 1, column: position[:column] - 2},
    ]
    board.each_with_index do |row, column_index| 
      row.each_with_index do |field, row_index|
        print " "
        if position[:row] == row_index && position[:column] == column_index
          print "X"
        elsif possible_moves_set.member?({row: row_index, column: column_index})
          print "O"
        else
          print "-"
        end
      end
      print "\n"
    end
  end
  board = Array.new(8){Array.new(8)}
  position = {column: 4, row: 4}
  printBoard(board, position)
=end

  class Node
    attr_reader :row, :column, :previous
    attr_accessor :edges
    def initialize(row = 0, column = 0, previous = nil, array = [])
      @row = row
      @column = column
      @edges = array
      @previous = previous
    end
  end
    
    
def possible_moves(root)
    row = root.row
    column = root.column
    if row + 2 <= 7 && column + 1 <= 7
      root.edges.push(Node.new(row + 2, column + 1, root))
    end
    if row + 2 <= 7 && column - 1 >= 0
      root.edges.push(Node.new(row + 2, column - 1, root))
    end
    if row - 2 >= 0 && column + 1 <= 7
      root.edges.push(Node.new(row - 2, column + 1, root))
    end
    if row - 2 >= 0 && column - 1 >= 0
      root.edges.push(Node.new(row - 2, column - 1, root))
    end
    if row + 1 <= 7 && column + 2 <= 7
      root.edges.push(Node.new(row + 1, column + 2, root))
    end
    if row + 1 <= 7 && column - 2 >= 0
      root.edges.push(Node.new(row + 1, column - 2, root))
    end
    if row - 1 >= 0 && column + 2 <= 7
      root.edges.push(Node.new(row - 1, column + 2, root))
    end
    if row - 1 >= 0 && column - 2 >= 0
      root.edges.push(Node.new(row - 1, column - 2, root))
    end
end

def shortest_path(start, target)
  root = Node.new(start[:row], start[:column])
  queue = [root, "new level"]
  depth = 0
  index = 0
  visited_set = Set.new
  while (true)
    curr = queue[index]
    index += 1
    if curr == "new level"
      queue.push("new level")
      if (queue[index] == "new level")
        break
      end
      depth += 1
      next
    end
    if visited_set.include?({row: curr.row, column: curr.column})
      next
    else
      visited_set.add({row: curr.row, column: curr.column})
    end
    if (curr.row == target[:row] && curr.column == target[:column])
      path = []
      until (curr.previous.nil?)
        path.push([curr.row, curr.column])
        curr = curr.previous
      end
      return {depth: depth, path: path}
    end
    possible_moves(curr)
    queue = queue + curr.edges
  end
end

knight_moves = shortest_path({row: 3, column: 3}, {row: 4, column: 3})
puts "You made it in #{knight_moves[:depth]} moves! Here's your path:"
path = knight_moves[:path]
until (path.empty?)
  move = path.pop
  p move
end