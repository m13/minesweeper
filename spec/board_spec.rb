# typed: false
# frozen_string_literal: true

require './src/board'

# rubocop:disable Metrics/BlockLength
RSpec.describe Board do
  # skipped
  # context '#initialize'

  # skipped
  # context '#add_bombs'

  context '#calculate_bombs' do
    let(:board) { Board.new(3, 0.0) }

    it 'should count edge bombs when in a corner' do
      board.board = Array.new(3) { Array.new(3, Board::BOMB) }
      expect(board.calculate_bombs(0, 0)).to eq(3)
    end

    it 'should count wall bombs when in the wall' do
      board.board = Array.new(3) { Array.new(3, Board::BOMB) }
      expect(board.calculate_bombs(0, 1)).to eq(5)
    end

    it 'should count all bombs when in the center' do
      board.board = Array.new(3) { Array.new(3, Board::BOMB) }
      expect(board.calculate_bombs(1, 1)).to eq(8)
    end
  end

  # skipped
  # context '#exists?'

  # skipped
  # context '#bomb?'

  context '#visible?' do
    it 'should true if contains a number' do
      board = Board.new(1, 0.0)
      board.board[0, 0] = 414_615
      expect(board.visible?(0, 0)).to eq(true)
    end

    it 'should false if does not contain a number' do
      board = Board.new(1, 0.0)
      board.board[0, 0] = '755548'
      expect(board.visible?(0, 0)).to eq(false)
    end
  end

  context '#value' do
    it 'should return value whatever it is' do
      board = Board.new(1, 0.0)
      board.board[0][0] = 820_595
      expect(board.value(0, 0)).to eq(820_595)
    end
  end

  # skipped
  # context '#last_bomb?'

  # skipped
  # context '#filtered_board'
end
# rubocop:enable Metrics/BlockLength
