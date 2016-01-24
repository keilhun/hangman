require "pp"

module Hangman
  require "yaml"
  class Game
    def initialize
        new_game()
        
    end
    
    def new_game
      @words = Array.new
      @secret_word = ""
      @misses = Array.new
      @output_word = ""
      read_dictionary()
      secret_word()
    end
    
    def save_game
      yaml_out = YAML.dump(self)
      
      save_file = "save1L.sav"
      rename_file = ""
      save_file_template = "./save/save*.sav"
      
      if (!Dir.exist?("save"))
        Dir.mkdir("save")
      elsif (!Dir[save_file_template].empty?)   # save files exist?
        cur_sav_file = Dir["save/*L.sav"]
        number = cur_sav_file[0].scan(/\d+/)
       # number = cur_save_file[4,1]
        number = number[0].to_i
        if number < 10
          number += 1
          save_file = 'save' + number.to_s + 'L.sav'
          rename_file = "save/save" + (number-1).to_s + ".sav"
        else
          rename_file = "save/save10.sav"
        end
      end
      save_file = "save/" + save_file
      File.open(save_file, "w") {|f| f.write(yaml_out)}
      if (rename_file != "")
        File.rename(cur_sav_file[0], rename_file)
      end
    end
    
    def load_game
      stop = false
      if Dir.exist?("save")          # save directory exists
        save_files = Dir["save/*.sav"]   # get all save files
        while stop == false
          save_files.each_with_index do |f, index|
            puts "#{index+1}. #{save_files[index]}\t#{File.ctime(f)}"
          end
          print "Please enter the number of the save file you wish to load"
          file_number = gets.chomp.to_i
          if file_number <= 10
              filename = save_files[file_number-1]
              file = File.open(filename, "r")
              text = file.read
              saved_game = YAML::load(text)
              saved_game.play
              stop = true
          else
            puts "No such file number. Please try again"
          end
        end
      else
        puts "There are no save files to load."
      end
    end
    
    def read_dictionary
        dictionary = File.open("5desk.txt", "r+")
        @words = dictionary.readlines
        @words.each_with_index do |word, index|
          @words[index] = word.chomp
        end
        #pp @words
    end
    
    def secret_word
      word = ""
      limit = @words.length
      until (word.length >= 5 && word.length <= 12)
        word = @words[rand(limit)]
      end
      @secret_word = word
      @secret_word.length.times do |k|
        @output_word = @output_word + "_"
      end
      pp @output_word
    end
    
    def display_word
      puts "Current word = #{@output_word}, misses = #{@misses.join}"
    end
    
    def check_letter(letter)
      return letter =~ /[[:alpha:]]/
    end
    
    def check_answer(user_input)
      if user_input == @secret_word
        puts "Congratulations You Won"
      else
        puts "Wrong Answer. The word was #{@secret_word}"
      end
      print "Do you want to play again (Y/N): "
      answer = gets.chomp.downcase
      if answer == "y"
        new_game()
        return false
      else
        return true
      end 
    end
    
    def check_input(user_input)
      case user_input
      when "save"
        save_game()
        exit = true
      when "load"
        load_game()
        exit = true
      when "exit"
        exit = true
      else
        exit = check_answer(user_input)
      end
      return exit
    end
    
    def find_letter(letter)
      if @secret_word.index(letter)
        @secret_word.split("").each_with_index do |value, index|
          if value == letter
              @output_word[index] = letter
          end
        end
      else
        @misses << letter
      end
    end
    
    def play
      stop = false
      puts "Welcome to the game of Hangman, try to guess the word"
      until (stop) do
        display_word()
        print "Please enter a letter you think is in the word: "
        user_input = gets.chomp.downcase
        if (user_input.length > 1)
            stop = check_input(user_input)
        elsif (check_letter(user_input))
          find_letter(user_input)
        else
        end
      end
    end
  end
end

game = Hangman::Game.new
#game = Game.new
game.play

