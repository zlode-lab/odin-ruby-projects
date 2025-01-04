module AskPlayer
  private
  def yes_no(return_yes = true, return_no = false)
    while true
      case gets.chomp.downcase
      when 'y', 'yes', 'ye', 'ya'
        return return_yes
      when 'n', 'no', 'nay'
        return return_no
      else
        puts "answer not valid.\nvalid examples: 'y', 'n', 'no', 'yes'"
      end
    end
  end

  def play_again?
    puts 'Would you like to play again? Y/N'
    return yes_no()
  end

  def save_game?
    puts 'do you want to save the game and exit? Y/N'
    return yes_no()
  end

  def load_save?
    puts 'do you want to load a save? Y/N'
    return yes_no(choose_save(), false)
  end

  def continue_loading?
    puts "Would you like to continue loading saves?"
    return yes_no()
  end

  def are_you_sure?
    'Are you sure you want to delete the save?'
    return yes_no()
  end

  def custom_dictionary?
    puts "Would you like to use a custom dictionary? Y/N"
    return yes_no()
  end
  
  def default_dictionary?
    puts "Would you like to use a default dictionary instead? Y/N"
    return yes_no(false, true)
  end
  
  def max_wrong_guesses
    puts 'What is the maximum of wrong guesses? (1-25)'
    while true
      input = gets.chomp.to_i
      return input if input.between?(1, 25)
      puts 'Not a valid input. Must be a number between 1 and 25.'
    end
  end

  def guess(past_guesses)
    puts 'what letter or word are you guessing?'
    input = gets.chomp.downcase
    result = ''
    while result == ''
      if past_guesses.include?(input) || player_guess.length < 1
        "You have already tried that. Guess something else:\nYour past guesses: #{past_guesses.to_s}" 
        input = gets.chomp.downcase
      else
        result = input
      end
    end
    result
  end

  def load_name
    print_saves()
    continue = true
    while continue
      puts 'What save would you like to load? (type its name)'
      name = gets.chomp
      name += '.csv' if name[-1..-4] !== '.csv'
      unless File.exist?("save #{name}")
        puts "file with name: '#{name}' doesn't exist"
        continue = continue_loading?
      else
        return name
      end
    end
    return ''
  end

  def save_name
    print_saves()
    while true
      puts 'What would you like to name your save?'
      name = gets.chomp + '.csv'
      if File.exist?("save #{name}")
        puts "file with name: '#{name}' already exists, would you like to overwrite it? Y/N"
        return name if yes_no()
      end
    end
  end

  def delete_or_load?
    while true
      puts "Would you like to load, or delete the save?\n 1 = 'load' || 2 = 'delete'"
      case gets.chomp.downcase
      when '1', 'load', 'l'
        return 'load'
      when '2', 'delete', 'd', 'del'
        return 'delete' if are_you_sure?()
      else
        puts "answer not valid.\nvalid examples: '1', 'load', '2', 'delete'"
      end
    end
  end

  def print_saves
    Dir['./saves/*.csv'].each{ |file| puts file }
  end

  def dictionary_path
    continue = true
    while continue
      puts 'What is the path (and name) to/of your dictionary'
      name = gets.chomp
      name += '.csv' if name[-1..-4] !== '.csv'
      unless File.exist?("save #{name}")
        puts "File with name: '#{name}' doesn't exist"
        continue = default_dictionary?
      else
        return name
      end
    end
    return dictionary.csv
  end

end


class Hangman
  private
  include AskPlayer

  def initialize(dictionary = load_dictionary, save = generate_new_game)
    @dictionary = dictionary
    @random_word = save[:random_word]
    @word_hash = save[:word_hash]
    @wrong_guesses = save[:rong_guesses]
    @past_guesses = save[:past_guesses]
    @max_wrong_guesses = save[:max_wrong_guesses]
  end

  def generate_new_game
    {
      random_word: dictionary[rand(dictionary.size)]
      word_hash: random_word.chars.reduce(Hash.new(false)) { |hash, letter| hash[letter]}
      wrong_guesses: 0
      past_guesses: []
      max_wrong_guesses: AskPlayer.max_wrong_guesses
    }
  end

  def load_dictionary(dictionary = 'dictionary.csv', min_letters = 5, max_letters = 15)
    dictionary = File.readlines(dictionary)
    dictionary = dictionary.filter{ |word| word.length.between?(min_letters, max_letters) }
  end

  def make_new_game
    if AskPlayer.custom_dictionary?
      Hangman.new(load_dictionary(AskPlayer.dictionary_path))
    else
      Hangman.new
    end
  end

  def game
    while wrong_guesses < max_wrong_guesses do
      display_current_state(past_guesses, wrong_guesses)
      if AskPlayer.save_game?
        save_game()
        return 'exit'
      end
      player_guess = AskPlayer.guess(past_guesses)
      past_guesses << player_guess
      if check_guess(random_word, player_guess) == 'win'
        puts "Congrats you won!\nthe word was: #{random_word}"
        return
      end
    end
    puts "You lost...\nthe word was: #{random_word}"
  end

  def check_guess(save, player_guess)
    return 'win' if player_guess == save[:random_word]
    if player_guess.length < 1
      if save[:random_word].include?(player_guesss)
        save[:word_hash][:player_guess] = true
        return 'win' unless save[:word_hash].value?(false)
    end
    save[wrong_guesses] += 1
  end

  def display_current_state(save)
    "wrong guesses made: #{save[wrong_guesses]} / #{save[max_wrong_guesses]}"
    "guesses made: #{save[past_guesses]}"
    puts random_word.chars.reduce('') |result_str, letter| do
      result_str += save[word_hash][letter] ? "#{letter} " : '_ '
    end
  end

  def choose_save
    continue = true
    while continue
      save_name = AskPlayer.load_name
      return 'exit' unless File.exist?("save/#{save_name}")
      if AskPlayer.delete_or_load? == 'load'
        return File.open("save/#{save_name}")
      else
        File.delete("save/#{save_name}")
      end
      continue = AskPlayer.continue_loading?
    end
  end

  def save_game
    save_name = AskPlayer.save_name
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(save_name, 'w') do |file|
      file.puts(self)
    end
    return
  end
 
  public

  def self.play
    playing? = true
    while playing?
      save = AskPlayer.load_save? ? choose_save : make_new_game
      unless game(save) == 'exit'
        playing? = AskPlayer.play_again?
      else
        playing? = false
      end
    end
    puts 'Thanks for playing!'
  end

end
  
Hangman.play