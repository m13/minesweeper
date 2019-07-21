# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
require './src/board'

##
# Controller to track status and total of bombs depending of its difficulty
# Status can be ONGOING, WIN and LOST
#
class Game
  extend T::Sig

  # model Board
  attr_accessor(:board)

  # state machine
  attr_accessor(:status)

  ONGOING = :ongoing
  WIN = :win
  LOST = :lost

  RATIO = {
    easy: 0.1,
    medium: 0.3,
    hard: 0.5
  }.freeze

  sig { params(size: Integer, difficulty: Symbol).returns(T.nilable(Board)) }
  def initialize(size, difficulty)
    @status = ONGOING
    @board = Board.new(size, bomb_percentage(difficulty))
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
  def filtered_board
    @board.filtered_board
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
