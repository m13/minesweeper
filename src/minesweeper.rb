# Interface
class Minesweeper

  def initialize(size, difficulty)
    p "#{size} #{difficulty}"
  end

  def attempt(x, y)
    p "#{x} #{y}"
  end

  def status
    p 'status'
  end

  def display
    p 'display'
  end
end