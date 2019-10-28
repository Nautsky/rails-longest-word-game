require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    if english?(@word) && is_grid?(@word, @letters)
      # calculate score
      score = @user['length'].to_i**2
      @result = "Congratulations! #{@word} is a word and gives you a score of #{score}"
    elsif is_grid?(@word, @letters) && (english?(@word) == false)
      @result = "Sorry, but #{@word} is not a word."
    elsif (is_grid?(@word, @letters) == false) && (english?(@word) == false)
      @result = "Cheater or careless? #{@word} cannot be created from #{@letters}!"
    end
  end

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    @user = JSON.parse(user_serialized)
    @user['found']
  end

  def is_grid?(attempt, grid)
    attempt_final = attempt.upcase.chars
    attempt_final.all? { |letter| grid.count(letter) >= attempt_final.count(letter) }
  end
end
