require "pp"

module Hangman
  class Game
    def initialize
        @words = Array.new
        @secret_word = ""
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
      while (word.length >= 5 && word.length <= 12)
        word = @words[rand(limit)]
      end
      @secret_word = word
      pp @secret_word
    end
  end 
end

game = Hangman::Game.new
game.read_dictionary
game.secret_word
game.secret_word
game.secret_word
