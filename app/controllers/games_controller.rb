require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(8)
    @my_score = session[:total_score].nil? ? 0 : session[:total_score]
  end

  def score
    @ans = params[:answer].downcase
    @letters = params[:letters].downcase.split
    response = open('https://wagon-dictionary.herokuapp.com/' + @ans)

    session[:total_score] ||= 0

    if !letters_in_grid
      @message = "The word can't be built out of the original grid"
    elsif !JSON.parse(response.read)['found']
      @message = 'The word is valid according to the grid, but is not a valid English word'
    else
      @message = 'The word is valid according to the grid and is an English word'
      session[:total_score] += 1
    end
  end

  private

  def letters_in_grid
    good_letters = true
    @ans.chars.each do |letter|
      good_letters = false unless @letters.include? letter
      @letters.delete_at(@letters.index(letter)) if @letters.index(letter)
    end
    good_letters
  end

  def reset
    reset_session
    redirect_to new_path
  end
end
