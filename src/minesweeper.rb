# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
require 'securerandom'
require './src/game'

# Viewer
class Minesweeper
  extend T::Sig

  attr_accessor(:game)

  sig { params(size: Integer, difficulty: Symbol).returns(T.nilable(Game)) }
  def initialize(size, difficulty)
    @game = Game.new(size, difficulty)
  rescue SizeOutOfBoundariesError
    puts 'Size is too small or too big'
  rescue UnknownDifficultyError
    puts 'Unknown difficulty'
  end

  sig { params(pos_x: Integer, pos_y: Integer).returns(T.nilable(Integer)) }
  def attempt(pos_x, pos_y)
    return puts 'Already over!' unless @game.ongoing?

    puts @game.attempt!(pos_x - 1, pos_y - 1)
  rescue BombFoundError
    puts 'BOOOOM!'
  rescue BoardInvalidCoordinateError
    puts 'Invalid coordinate!'
  end

  sig { void }
  def status
    if @game.ongoing?
      puts 'Still playing'
    elsif @game.won?
      puts 'You won!'
    elsif @game.lost?
      puts 'You lost!'
    else
      puts 'Unknown status'
    end
  end

  sig { void }
  def display
    @game.board.each do |column|
      puts column.join(' ')
    end
  end
end
