class Game
  private
  attr_accessor :board
  attr_reader :win_length, :size
  def initialize(size = 15, win_length = 4)
    @board = Array.new(size){Array.new(size)}
    @win_length = win_length
    @size = size -1
  end

  def checkDiagonal(field, hash)
    case field
    when "X"
      return "X" if (hash[:X] += 1) == win_length
      hash[:O] = 0
    when "O"
      return "O" if (hash[:O] += 1) == win_length
      hash[:X] = 0
    when nil
      hash[:X] = 0
      hash[:O] = 0
    end
    return false
  end

  public

  def printBoard
    board.each do |row| 
      row.each do |field|
        print " "
        case field
        when "X"
          print "X"
        when "O"
          print "O"
        when nil 
          print "-"
        else
          print field
        end
      end
      print "\n"
    end
  end
  def make_turn(column, row, mark_str)
    return board[column][row] == nil ? board[column][row] = mark_str : "taken"
  end
  def checkWinConnect
    points = Hash.new(0)
    draw = true
    points = {
      column_x: Hash.new(0),
      column_o: Hash.new(0),
      row_x: 0,
      row_o: 0,
      top_left: {X: 0, O: 0},
      top_right: {X: 0, O: 0},
      bottom_right: {X: 0, O: 0},
      bottom_left: {X: 0, O: 0}
    }
    board.each_with_index do |row, column_index| 
      checkDiagonal(nil, points[:top_left])
      checkDiagonal(nil, points[:top_right])
      checkDiagonal(nil, points[:bottom_right])
      checkDiagonal(nil, points[:bottom_left])
      row.each_with_index do |field, index|
        if index <= column_index then #diagonal check
          return board[column_index-index][index] if checkDiagonal(board[column_index-index][index], points[:top_left])
          return board[index][size-column_index+index] if checkDiagonal(board[index][size-column_index+index], points[:top_right])
          return board[size-column_index+index][size-index] if checkDiagonal(board[size-column_index+index][size-index], points[:bottom_right])
          return board[size-index][column_index-index] if checkDiagonal(board[size-index][column_index-index], points[:bottom_left])
        end
        case field
        when "X"
          return "X" if (points[:column_x][index] += 1) == win_length
          return "X" if (points[:row_x] += 1) == win_length
          points[:column_o][index] = 0
          points[:row_o] = 0
        when "O"
          return "O" if (points[:column_o][index] += 1) == win_length
          return "O" if (points[:row_o] += 1) == win_length
          points[:column_x][index] = 0
          points[:row_x] = 0
        when nil
          draw = false
          points[:column_o][index] = 0
          points[:column_x][index] = 0
          points[:row_x] = 0
          points[:row_o] = 0
        end
      end
    end
    return draw
  end
  public
end
class TicTacToe
  private
  attr_accessor :game, :player1, :player2, :size
  def initialize
    @size = 3
    @wincon = 3
    @game = Game.new(@size, @wincon)
    @player1 = {name: "Player 1", mark: "X"}
    @player2 = {name: "Player 2", mark: "O"}
  end
  def is_valid?(input)
    return false unless input.length.between?(2, 3)
    for index in 0..input.length-1 do
      if input[index].bytes[0].between?(65, 64+size) then
        unless defined?(letter_index) then
          letter_index = index
        else
          return false
        end
      end
    end
    return false unless defined?(letter_index) && !letter_index.nil?
    letter = input.slice!(letter_index)
    return false unless input.to_i.between?(1, size)
    return[letter.bytes[0] - 65, input.to_i - 1]
  end 
  def get_input
    input = gets.chomp
    return input if input == "stop"
    checked_input = is_valid?(input)
    if checked_input then
      return checked_input
    else
      max_letter = [64+size].pack('c' * 1)
      puts "Invalid input, valid input is range A-#{max_letter} for columns and 1-#{size} for rows."
      puts "Example: 'A12', '15Z', 'C3'"
      puts "Try again:"
      return get_input()
    end
  end
  public
  def play
    game_ongoing = true
    puts "Player 1 (X) name:"
    player1[:name] = gets.chomp
    different_name = false
    until different_name
      puts "Player 2 (O) name:"
      player2[:name] = gets.chomp
      player1[:name] == player2[:name] ? puts("Can't have the same name as another player!") : different_name = true
    end
    turn_count = 1
    while game_ongoing
      turn_count.odd? ? current_player = player1 : current_player = player2
      puts "What is #{current_player[:name]}'s turn? #{current_player[:mark]}"
      turn_succesful = false
      until turn_succesful
        try_again = false
        input = get_input()
        return puts "stopping the game" if input == "stop"
        game.make_turn(input[0], input[1], current_player[:mark]) == "taken" ? try_again = true : turn_succesful = true
        game.printBoard
        puts("that field is already taken, try again:") if try_again == true
      end
      win = game.checkWinConnect
      if win then
        puts win == true ?  "It's a draw..." : "Congrats #{current_player[:name]} (#{win}) won"
        game_ongoing = false
      end
      turn_count += 1
    end
  end
end

game = TicTacToe.new
game.play