# typed: false
# frozen_string_literal: true

require './src/game'

# rubocop:disable Metrics/BlockLength
RSpec.describe Game do
  # skipped
  # context '#initialize'

  context '#attempt!' do
    let(:game) { Game.new(2, :easy) }

    it 'should error when positions are wrong' do
      expect { game.attempt!(999, 999) }.to raise_error(BoardInvalidCoordinateError)
    end

    it 'should return previous value if was already calculated' do
      allow(game.board).to receive(:exists?).and_return(true)
      allow(game.board).to receive(:visible?).and_return(true)
      allow(game.board).to receive(:value).and_return(283_921)
      expect(game.attempt!(1, 1)).to eq(283_921)
    end

    it 'should lose when bomb is found' do
      allow(game.board).to receive(:exists?).and_return(true)
      allow(game.board).to receive(:visible?).and_return(false)
      allow(game.board).to receive(:bomb?).and_return(true)
      expect { game.attempt!(1, 1) }.to raise_error(BombFoundError)
      expect(game.status).to eq(Game::LOST)
    end

    it 'should return new value when there was no bomb' do
      allow(game.board).to receive(:exists?).and_return(true)
      allow(game.board).to receive(:visible?).and_return(false)
      allow(game.board).to receive(:bomb?).and_return(false)
      allow(game.board).to receive(:calculate_bombs).and_return(355_375)
      expect(game.attempt!(1, 1)).to eq(355_375)
    end

    it 'should win when this is the last empty gap found' do
      allow(game.board).to receive(:exists?).and_return(true)
      allow(game.board).to receive(:visible?).and_return(false)
      allow(game.board).to receive(:bomb?).and_return(false)
      allow(game.board).to receive(:last_bomb?).and_return(true)
      allow(game.board).to receive(:calculate_bombs).and_return(971_196)
      game.attempt!(1, 1)
      expect(game.status).to eq(Game::WIN)
    end
  end

  context '#ongoing?' do
    it 'should return boolean on status' do
      game = Game.new(2, :easy)
      game.status = false
      expect(game.ongoing?).to eq(false)
      game.status = Game::ONGOING
      expect(game.ongoing?).to eq(true)
    end
  end

  context '#won?' do
    it 'should return boolean on status' do
      game = Game.new(2, :easy)
      game.status = false
      expect(game.won?).to eq(false)
      game.status = Game::WIN
      expect(game.won?).to eq(true)
    end
  end

  context '#lost?' do
    it 'should return boolean on status' do
      game = Game.new(2, :easy)
      game.status = false
      expect(game.lost?).to eq(false)
      game.status = Game::LOST
      expect(game.lost?).to eq(true)
    end
  end

  # skipped
  # context '#filtered_board'

  # skipped
  # context '#bomb_percentage'
end
# rubocop:enable Metrics/BlockLength
