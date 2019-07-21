# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
require 'securerandom'
require './src/board'

# Controller
class Game
  extend T::Sig

  ONGOING = :ongoing
  WIN = :win
  LOST = :lost

  RATIO = {
    easy: 0.1,
    medium: 0.3,
    hard: 0.5
  }.freeze

  sig { params(size: Integer, difficulty: Symbol).void }
  def initialize(size, difficulty)
    @board = Board.new(size, bomb_percentage(difficulty))
    @status = ONGOING
  end

  sig { params(pos_x: Integer, pos_y: Integer).returns(T.nilable(Integer)) }
  def attempt!(pos_x, pos_y)
    raise BoardInvalidCoordinateError unless @board.exists?(pos_x, pos_y)
    return @board.value(pos_x, pos_y) if @board.visible?(pos_x, pos_y)

    if @board.bomb?(pos_x, pos_y)
      @status = LOST
      raise BombFoundError
    end

    @status = WIN if @board.last_bomb?
    @board.calculate_bombs(pos_x, pos_y)
  end

  sig { returns(T::Boolean) }
  def ongoing?
    @status == ONGOING
  end

  sig { returns(T::Boolean) }
  def won?
    @status == WIN
  end

  sig { returns(T::Boolean) }
  def lost?
    @status == LOST
  end

  sig { returns(Array) }
  def board
    @board.display
  end

  private

  sig { params(difficulty: Symbol).returns(Float) }
  def bomb_percentage(difficulty)
    raise UnknownDifficultyError unless RATIO[difficulty]

    RATIO[difficulty]
  end
end

class BoardInvalidCoordinateError < StandardError; end
class BombFoundError < StandardError; end
class UnknownDifficultyError < StandardError; end