require 'open-uri'
require 'json'

class WordGameController < ApplicationController
  def game

    def generate_grid(grid_size)
      Array.new(grid_size) { ('A'..'Z').to_a.sample }
    end

    @grid = generate_grid(9).join(" ")

    @start_time = Time.now
  end

  def score
    @attempt = params[:attempt]
    @game_grid = params[:game_grid]

    start_time = params[:start_time].to_datetime
    end_time = Time.now
    @time_taken =  end_time - start_time


    if included?(@attempt, @game_grid) == true

      if english_word?(@attempt) == true
        @score = compute_score(@attempt, @time_taken)
        @message = "Well done!"

      else
        @score = 0
        @message = "Not an english word"
      end

    else
      @score = 0
      @message = "Not included in grid"
    end
  end


  def included?(word, grid)
    word.chars.all? { |letter| word.upcase.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end
end








