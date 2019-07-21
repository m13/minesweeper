# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
require 'securerandom'

# Interface
class Minesweeper
  extend T::Sig

  DEFAULT = 'X'
  BOMB = 'B'

  RATIO = {
    easy: 0.1,
    medium: 0.3,
    hard: 0.5
  }.freeze

  ONGOING = :ongoing
  WIN = :win
  LOST = :lost

  STATUS = {
    ONGOING => 'Still playing',
    WIN => 'You won!',
    LOST => 'You lost!'
  }.freeze

  sig { params(size: Integer, difficulty: Symbol).void }
  def initialize(size, difficulty)
    raise 'Wrong difficulty' unless RATIO[difficulty]

    @board = Array.new(size) { Array.new(size, DEFAULT) }
    length = size * size
    bombs = (length * RATIO[difficulty]).ceil
    @missing = length - bombs
    while bombs.positive?
      x_and_y = SecureRandom.random_number(length)
      if @board[x_and_y % size][x_and_y / size] != BOMB
        @board[x_and_y % size][x_and_y / size] = BOMB
        bombs -= 1
      end
    end
    @status = ONGOING
  end

  sig { params(pos_x: Integer, pos_y: Integer).returns(T.nilable(Integer)) }
  def attempt(pos_x, pos_y)
    pos_x -= 1
    pos_y -= 1
    if @status != ONGOING
      puts 'Start again!'
    elsif @board[pos_x].nil? || @board[pos_x][pos_y].nil?
      puts 'Invalid coordinate!'
    elsif @board[pos_x][pos_y] == BOMB
      @status = LOST
      puts 'BOOOOM!'
    elsif @board[pos_x][pos_y] == DEFAULT
      @board[pos_x][pos_y] = 0
      3.times do |i|
        3.times do |j|
          next if i == 1 && j == 1
          next if (pos_x - 1 + i).negative?
          next if (pos_y - 1 + j).negative?
          next unless @board[pos_x - 1 + i]
          next unless @board[pos_x - 1 + i][pos_y - 1 + j] == BOMB

          @board[pos_x][pos_y] += 1
        end
      end

      @missing -= 1
      @status = WIN if @missing.zero?

      @board[pos_x][pos_y]
    elsif @board[pos_x][pos_y].positive?
      puts 'You knew me...'
    end
  end

  sig { void }
  def status
    @board.each do |column|
      column.collect do |row|
        print "#{row == BOMB ? 'b' : row.to_s} "
      end
      print "\n"
    end
  end

  sig { void }
  def display
    puts STATUS[@status]
  end
end
