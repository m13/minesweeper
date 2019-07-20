# frozen_string_literal: true

require "#{__dir__}/../src/minesweeper"

RSpec.describe Minesweeper do
  context '#status' do
    it 'should return status' do
      game = Minesweeper.new(10, :easy)
      expect { game.status }.to output(/status/).to_stdout
    end
  end
end
