module MastermindLimits
  private
  def self.elements(secret_code_elements)
    #check if its number/string and convert to integer
    if secret_code_elements < 1
      puts "secret code can't be composed from less than one element, setting elements to 6"
      return 6
    end 
    if secret_code_elements > 52
      puts "secret code can't be composed from more than fifty-two different elements, setting elements to 52" 
      return 52
    end
    return secret_code_elements
  end
  def self.game_length(game_length)
    if game_length < 1
      puts "game length has to be at least one turn, setting game length to 6"
      return 6
    end 
    if game_length > 100
      puts "game can't be longer than hundred turns, setting game length to 100" 
      return 100
    end
    return game_length
  end
  def self.secret_code_length(secret_code_length)
    if secret_code_length < 1
      puts "secret code length has to be at least one letter, setting secret code length to 4"
      return 4
    end 
    if secret_code_length > 100
      puts "secret code length can't be longer than hundred letter, setting secret code length to 100" 
      return 100
    end
    return secret_code_length
  end
end

module MastermindPlayerInput
  private
  def figure_player_role
    valid_choice_made = false
    puts "do you want to be the code breaker or code setter?\ntype:\nA) code breaker\nB) code setter"
    until valid_choice_made
      input = gets.chomp.downcase
      case input
      when "a", "code breaker", "breaker"
        player_role = "Code Breaker"
        valid_choice_made = true
      when "b", "code setter", "setter"
        player_role = "Code Setter"
        valid_choice_made = true
      else
        puts "input is not valid, try again:\nvalid examples: 'A', 'b', 'Setter', 'Code BREAKER'"
      end
    end
    return player_role
  end
  def ask_for_code(secret_code_length, secret_code_elements)
    if secret_code_elements < 27
      max_letter = [64+secret_code_elements].pack('c' * 1)
    elsif secret_code_elements == 27
      max_letter = "Z, and lowercase a"
    else
      max_letter = "Z, a-#{[96+secret_code_elements-26].pack('c' * 1)}"
    end
    puts "What is your secret code? Max length: #{secret_code_length}, Options: A-#{max_letter}"
    input = gets.chomp
    #check input
    return input
  end
end

class Board
  private
  attr_accessor :board
  def initialize(column = 6, row = 4)
    @board = Array.new(column){Array.new(row)}
  end
  public

  def printBoard
    board.each do |row| 
      row.each do |field|
        print " "
        case field
        when nil 
          print "-"
        else
          print field
        end
      end
      print "\n"
    end
  end
end

class Mastermind
  private
  attr_accessor :secret_code, :board
  attr_reader :secret_code_elements
  include MastermindLimits, MastermindPlayerInput
  def initialize(game_length = 6, secret_code_length = 4, secret_code_elements = 6)
    @board = Board.new(MastermindLimits.game_length(game_length), MastermindLimits.secret_code_length(secret_code_length))
    #add hints to board print
    @secret_code = Array.new(MastermindLimits.secret_code_length(secret_code_length))
    @secret_code_elements = MastermindLimits.elements(secret_code_elements)
    @game_length = game_length
  end
  
  public
  def play
    current_turn = 0
    player_role = figure_player_role()
    secret_code = player_role == "Code Breaker" ? generate_code(secret_code_length, secret_code_elements) : ask_for_code(secret_code_length, secret_code_elements)
    #generate code if they want to be breaker
    #ask what their guess is/make algorithm guess
    #check their guess and give them a hint/call out player if they are lying
    #repeat until someone guesses right or current turn reaches game lenght
    #announce the winner and ask the player to play again
  end
end

mastermind = Mastermind.new
mastermind.play