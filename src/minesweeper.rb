# frozen_string_literal: true

# Interface
class Minesweeper
  def initialize(size, difficulty)
    p "#{size} #{difficulty}"
  end

  def attempt(pos_x, pos_y)
    p "#{pos_x} #{pos_y}"
  end

  def status
    p 'status'
  end

  def display
    p 'display'
  end
end
