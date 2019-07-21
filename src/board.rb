# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
require 'securerandom'

##
# Model to manipulate board, specially with its bombs
# There are 4 types:
# - nil (out of boundary)
# - X (hidden / not seen yet)
# - B (bomb!) but displayed as X
# - Number (once discovered contains the total of surrounding bombs)
#
class Board
  extend T::Sig

  # array of array
  attr_accessor(:board)

  # bombs until game is finished
  attr_accessor(:missing)

  DEFAULT = :X
  BOMB = :B

  sig { params(size: Integer, bomb_percentage: Float).returns(T.nilable(Integer)) }
  def initialize(size, bomb_percentage)
    raise SizeOutOfBoundariesError unless size.positive? && size <= 100

    @board = Array.new(size) { Array.new(size, DEFAULT) }
    square = size * size
    bombs = (square * bomb_percentage).ceil

    add_bombs(square, size, bombs)
    @missing = square - bombs
  end

  sig { params(max: Integer, size: Integer, bombs: Integer).void }
  def add_bombs(max, size, bombs)
    while bombs.positive?
      x_and_y = SecureRandom.random_number(max)
      unless bomb?(x_and_y % size, x_and_y / size)
        @board[x_and_y % size][x_and_y / size] = BOMB
        bombs -= 1
      end
    end
  end

  sig { params(pos_x: Integer, pos_y: Integer).returns(T.nilable(Integer)) }
  def calculate_bombs(pos_x, pos_y)
    @board[pos_x][pos_y] = 0
    3.times do |i|
      3.times do |j|
        @board[pos_x][pos_y] += 1 if bomb?(pos_x - 1 + i, pos_y - 1 + j)
      end
    end
    @missing -= 1
    @board[pos_x][pos_y]
  end

  sig { params(pos_x: Integer, pos_y: Integer).returns(T::Boolean) }
  def exists?(pos_x, pos_y)
    pos_x >= 0 && pos_y >= 0 && !@board[pos_x].nil? && !@board[pos_x][pos_y].nil?
  end

  sig { params(pos_x: Integer, pos_y: Integer).returns(T::Boolean) }
  def bomb?(pos_x, pos_y)
    exists?(pos_x, pos_y) && @board[pos_x][pos_y] == BOMB
  end

  sig { params(pos_x: Integer, pos_y: Integer).returns(T::Boolean) }
  def visible?(pos_x, pos_y)
    exists?(pos_x, pos_y) && @board[pos_x][pos_y].is_a?(Numeric)
  end

  sig { params(pos_x: Integer, pos_y: Integer).returns(Integer) }
  def value(pos_x, pos_y)
    @board[pos_x][pos_y]
  end

  sig { returns(T::Boolean) }
  def last_bomb?
    @missing == 1
  end

  sig { returns(Array) }
  def filtered_board
    @board.collect do |column|
      column.collect do |row|
        row == BOMB ? DEFAULT : row.to_s
      end
    end
  end
end

class SizeOutOfBoundariesError < StandardError; end
