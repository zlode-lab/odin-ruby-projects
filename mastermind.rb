require 'set'

module MastermindLimits
  private
  def self.elements(secret_code_elements)
    #check if its number/string and convert to integer
    if secret_code_elements < 2
      puts "secret code can't be composed from less than two element, setting elements to 6"
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

  def ask_for_code(secret_code_length, secret_code_elements, guess = false)
    if secret_code_elements < 27
      max_letter = [64+secret_code_elements].pack('c' * 1)
      max_option = [64+secret_code_elements].pack('c' * 1)
    elsif secret_code_elements == 27
      max_letter = [97].pack('c' * 1)
      max_option = "Z, and lowercase a"
    else
      max_letter = [96+secret_code_elements-26].pack('c' * 1)
      max_option = "Z, a-#{[96+secret_code_elements-26].pack('c' * 1)}"
    end
    puts "What is your #{guess ? "guess" : "secret code"}? Max length: #{secret_code_length}, Options: A-#{max_letter}"
    while true
      input = gets.chomp
      #check input
      if input.length == secret_code_length
        if input.chars.all? { |letter| letter.between?("A", max_letter) && !letter.between?("[", "`") }
          return input
        end
      end
      puts "Your #{guess ? "guess" : "secret code"} is not valid, try again... note: Case-sensitive! Max length: #{secret_code_length}, Options: A-#{max_letter}"
    end
  end

  def play_again?
    puts "Want to play again? Y/N"
    while true
      case gets.chomp.downcase
      when "y", "yes"
        return true
      when "n", "no", "stop"
        return false
      else
        puts "Wrong input, please type 'yes' or 'no'. Y/N"
      end
    end
  end
end

module MastermindFunctions
  private
  def generate_code(secret_code_length, secret_code_elements)
    secret_code = []
    while secret_code_length > secret_code.size
      secret_code.push(rand(1..secret_code_elements))
    end
    if secret_code_elements < 27
      return secret_code.map { |letter| letter += 64}.pack("c" * secret_code_length)
    else
      return secret_code.map { |letter| letter < 27 ? letter += 64 : letter += 70}.pack("c" * secret_code_length)
    end
  end

  def check_guess(guess, secret_code, letter_list)
    guess_arr = guess.chars
    correct_placement = 0
    correct_letter = 0
    secret_code.chars.each_index do |index|
      if secret_code[index] == guess_arr[index]
        letter_list[guess_arr[index]] -= 1
        correct_placement += 1
        guess_arr[index] = "0"
      end
    end
    secret_code.chars.each_index do |index|
      if letter_list[guess_arr[index]] > 0
        letter_list[guess_arr[index]] -= 1
        correct_letter += 1
      end
    end
    return {correct_placement: correct_placement, correct_letter: correct_letter}
  end

  def reduce_guess_set(hints, the_real_guess_set, last_guess)
    #p the_real_guess_set
    guess_set = the_real_guess_set.dup
    guess_set.delete(last_guess)
    if (hints[:correct_placement] == 0 && hints[:correct_letter] == 0) 
      last_guess.chars.each do |guess_letter|
        guess_set.delete_if do |str|
          str.include?(guess_letter)  
        end
      end
    else
      if (hints[:correct_placement] > 0)
        guess_set.keep_if do |str|
          correct_placements = last_guess.chars.each_with_index.reduce(0) do |total, (value, index)|
            if last_guess[index] == str[index]
              total += 1 
            end
            total
          end
          correct_placements == hints[:correct_placement] 
        end
      end
      if (hints[:correct_letter] > 0) 
        guess_set.keep_if do |str|
          str_hash = str.chars.tally
          correct_letters = last_guess.chars.reduce(0) do |total, last_guess_letter|
            if !str_hash[last_guess_letter].nil? && str_hash[last_guess_letter] > 0
              total += 1
              str_hash[last_guess_letter] -= 1
            end
            total 
          end
          correct_letters >= hints[:correct_letter]
        end
      end
    end
    return guess_set
  end

  POSSIBLE_HINTS = [
      {correct_placement:0, correct_letter: 0},
      {correct_placement:1, correct_letter: 0},
      {correct_placement:2, correct_letter: 0},
      {correct_placement:3, correct_letter: 0},
      {correct_placement:0, correct_letter: 1},
      {correct_placement:0, correct_letter: 2},
      {correct_placement:0, correct_letter: 3},
      {correct_placement:0, correct_letter: 4},
      {correct_placement:1, correct_letter: 1},
      {correct_placement:1, correct_letter: 2},
      {correct_placement:1, correct_letter: 3},
      {correct_placement:2, correct_letter: 1},
      {correct_placement:2, correct_letter: 2}
    ]
  def generate_guess(secret_code_length, secret_code_elements, guess_set)
    guess_arr = guess_set.to_a
    score_arr = guess_arr.map do |possible_guess|
      possible_guess = "ABCD"
      highscore = POSSIBLE_HINTS.reduce(0) do |highest_score, hints|
        score = reduce_guess_set(hints, guess_set, possible_guess).size
        highest_score = score if score > highest_score
        highest_score
      end
      highscore
    end
    return guess_arr[score_arr.index(score_arr.min)]
  end

  def two_value_guess(secret_code_length, current_turn)
    guess = ""
    str_one = [65+current_turn*2].pack('c')
    str_two = [65+current_turn*2+1].pack('c')
    if str_two.to_i > 90 
      str_two = [71+current_turn*2+1].pack('c')
      if str_one.to_i > 90
        str_one = [71+current_turn*2].pack('c')
      end
    end
    (secret_code_length/2.0).floor.to_i.times do
      guess.concat(str_one)
    end
    (secret_code_length/2.0).ceil.to_i.times do
      guess.concat(str_two)
    end
    return guess
  end
end

class Board
  private
  attr_accessor :board
  def initialize(column = 6, row = 4)
    @board = Array.new(column){Array.new(row)}
  end
  public

  def print_board
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

  def log_guess(guess, hints, current_turn)
    board[current_turn].each_index do |index|
      board[current_turn][index] = guess[index]
    end
    board[current_turn].push("correct placement: " + hints[:correct_placement].to_s)
    board[current_turn].push("correct letter: " + hints[:correct_letter].to_s)
  end

end

class Mastermind
  private
  attr_accessor :secret_code
  attr_reader :secret_code_elements, :secret_code_length, :game_length
  include MastermindLimits, MastermindPlayerInput, MastermindFunctions
  def initialize(game_length = 6, secret_code_length = 4, secret_code_elements = 6)
    @secret_code_length = secret_code_length
    @secret_code = Array.new(MastermindLimits.secret_code_length(secret_code_length))
    @secret_code_elements = MastermindLimits.elements(secret_code_elements)
    @game_length = game_length
  end
  def game_start
    board = Board.new(MastermindLimits.game_length(game_length), MastermindLimits.secret_code_length(secret_code_length))
    current_turn = 0
    player_role = figure_player_role()
    if player_role == "Code Breaker"
      secret_code = generate_code(secret_code_length, secret_code_elements) 
    else
      secret_code = ask_for_code(secret_code_length, secret_code_elements)
      if secret_code_elements < 27
        letters_arr = ("A"..([secret_code_elements + 64].pack('c'))).to_a # A, B, C, D, E, F
      else
        letters_arr = (("A" * secret_code_length)..("Z" * secret_code_length)).to_a
        letters_arr = letters_arr + (("a" * secret_code_length)..([secret_code_elements + 96].pack('c') * secret_code_length)).to_a
      end
      array = letters_arr
      (secret_code_length - 1).times do
        array = array.map{ |str| letters_arr.map { |letter| str + letter} }
        array.flatten!
      end
      guess_set = array.to_set
    end
    hints = {correct_placement:0, correct_letter: 0}
    two_value = true
    while current_turn < game_length
      guess = "AAAA"
      letter_list = Hash.new(0)
      secret_code.chars.each { |letter| letter_list[letter] += 1}
      if player_role == "Code Breaker" 
         guess = ask_for_code(secret_code_length, secret_code_elements, true) 
         hints = check_guess(guess, secret_code, letter_list)
      else
        two_value = false unless hints == {correct_placement:0, correct_letter: 0}
        guess = two_value ? two_value_guess(secret_code_length, current_turn) : generate_guess(secret_code_length, secret_code_elements, guess_set)
        hints = check_guess(guess, secret_code, letter_list)
        guess_set = reduce_guess_set(hints, guess_set, guess)
        p guess_set.size
      end
      board.log_guess(guess, hints, current_turn)
      board.print_board
      if hints[:correct_placement] == secret_code_length
        return puts("Code Breaker #{player_role == "Code Breaker" ? "(You)" : "(AI)"} won!") 
      end
      current_turn += 1
    end
    puts "The code was: #{secret_code}"
    return puts "Code Setter #{player_role == "Code Setter" ? "(You)" : "(AI)"} won!"
    #make algorithm guess
  end
  public
  def play
    playing = true
    game_start()
    while playing
      play_again?() ? game_start() : playing = false
    end
  end
end

mastermind = Mastermind.new
mastermind.play
