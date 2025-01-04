module AskPlayer
  private
  def self.yes_no(return_yes = true, return_no = false)
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

  def self.play_again?
    puts 'Would you like to play again? Y/N'
    return yes_no()
  end

  def self.save_game?
    puts 'do you want to save the game and exit? Y/N'
    return yes_no()
  end

  def self.load_save?
    puts 'do you want to load a save? Y/N'
    return yes_no()
  end

  def self.continue_loading?
    puts "Would you like to continue loading saves? Y/N"
    return yes_no()
  end

  def self.are_you_sure?
    puts 'Are you sure you want to delete the save? Y/N'
    return yes_no()
  end

  def self.custom_dictionary?
    puts "Would you like to use a custom dictionary? Y/N"
    return yes_no()
  end
  
  def self.default_dictionary?
    puts "Would you like to use a default dictionary instead? Y/N"
    return yes_no(false, true)
  end
  
  def self.max_wrong_guesses
    puts 'What is the maximum of wrong guesses? (1-25)'
    while true
      input = gets.chomp.to_i
      return input if input.between?(1, 25)
      puts 'Not a valid input. Must be a number between 1 and 25.'
    end
  end

  def self.guess(save)
    puts 'what letter or word are you guessing?'
    input = gets.chomp.downcase
    result = ''
    while result == ''
      if save.past_guesses.include?(input) || input.length < 1
        "You have already tried that. Guess something else:\nYour past guesses: #{save.past_guesses.to_s}" 
        input = gets.chomp.downcase
      else
        result = input
      end
    end
    result
  end

  def self.load_name
    print_saves()
    continue = true
    while continue
      puts 'What save would you like to load? (type its name)'
      name = gets.chomp
      name += '.csv' unless name[-1..-4] == '.csv'
      unless File.exist?("save #{name}")
        puts "file with name: '#{name}' doesn't exist"
        continue = continue_loading?
      else
        return name
      end
    end
    return ''
  end

  def self.save_name
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

  def self.delete_or_load?
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

  def self.print_saves
    Dir['./saves/*.csv'].each{ |file| puts file }
  end

  def self.dictionary_path
    continue = true
    while continue
      puts 'What is the path (and name) to/of your dictionary'
      name = gets.chomp
      name += '.csv' unless name[-1..-4] == '.csv'
      unless File.exist?("save #{name}")
        puts "File with name: '#{name}' doesn't exist"
        continue = default_dictionary?
      else
        return name
      end
    end
    return 'dictionary.csv'
  end

end


class Hangman
  public
  attr_accessor :wrong_guesses, :past_guesses, :word_hash
  attr_reader :max_wrong_guesses, :random_word
  private
  include AskPlayer
  
  def initialize(dictionary  = 'dictionary.csv', save = Hangman.generate_new_game(dictionary))
    @dictionary = Hangman.load_dictionary(dictionary)
    @random_word = save[:random_word]
    @word_hash = save[:word_hash]
    @wrong_guesses = save[:wrong_guesses]
    @past_guesses = save[:past_guesses]
    @max_wrong_guesses = save[:max_wrong_guesses]
  end

  def self.generate_new_game(dictionary)
    random_word = dictionary[rand(dictionary.size)] #doesnt return a word prolly takes in a string 'dictionary.csv' while initializing
    {
      random_word: random_word,
      word_hash: random_word.chars.reduce(Hash.new(false)) { |hash, letter| hash[letter]},
      wrong_guesses: 0,
      past_guesses: [],
      max_wrong_guesses: AskPlayer.max_wrong_guesses,
    }
  end

  def self.load_dictionary(dictionary = 'dictionary.csv', min_letters = 5, max_letters = 15)
    dictionary = File.readlines(dictionary)
    dictionary = dictionary.filter{ |word| word.length.between?(min_letters, max_letters) }
  end

  def self.make_new_game
    if AskPlayer.custom_dictionary?
      Hangman.new(load_dictionary(AskPlayer.dictionary_path))
    else
      Hangman.new
    end
  end

  def self.game(save)
    while save.wrong_guesses < save.max_wrong_guesses do
      display_current_state(save)
      if AskPlayer.save_game?
        save_game()
        return 'exit'
      end
      player_guess = AskPlayer.guess(save)
      save.past_guesses << player_guess
      if check_guess(save, player_guess) == 'win'
        puts "Congrats you won!\nthe word was: #{save.random_word}"
        return
      end
    end
    puts "You lost...\nthe word was: #{save.random_word}"
  end

  def self.check_guess(save, player_guess)
    return 'win' if player_guess == save.random_word
    if player_guess.length < 1
      if save.random_word.include?(player_guesss)
        save.word_hash[:player_guess] = true
        return 'win' unless save.word_hash.value?(false)
      end
    end
    save.wrong_guesses += 1
  end

  def self.display_current_state(save)
    puts "number of wrong guesses made: #{save.wrong_guesses} / #{save.max_wrong_guesses}"
    puts "list of guesses made: #{save.past_guesses}"
    puts save.random_word.chars.reduce('') do |result_str, letter| 
      result_str += save.word_hash[letter] ? "#{letter} " : '_ '
    end
  end

  def self.choose_save
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

  def self.save_game
    save_name = AskPlayer.save_name
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(save_name, 'w') do |file|
      file.puts(self)
    end
    return
  end
 
  public

  def self.play
    playing = true
    while playing
      save = AskPlayer.load_save? ? choose_save() : make_new_game
      unless game(save) == 'exit'
        playing = AskPlayer.play_again?
      else
        playing = false
      end
    end
    puts 'Thanks for playing!'
  end

end
  
#Hangman.play


random_word = dictionary[rand(dictionary.size)] #doesnt return a word