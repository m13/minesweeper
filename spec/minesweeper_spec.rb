# typed: false
# frozen_string_literal: true

require './src/minesweeper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Minesweeper do
  context '#initialize' do
    it 'should error when difficult is not found' do
      expect { Minesweeper.new(10, :xxx) }.to output(/Unknown difficulty/).to_stdout
    end

    it 'should error when size is lower than 0' do
      expect { Minesweeper.new(-1, :easy) }.to output(/Size is too small or too big/).to_stdout
    end

    it 'should error when size is higher than 100' do
      expect { Minesweeper.new(101, :easy) }.to output(/Size is too small or too big/).to_stdout
    end

    it 'should succeed with valid params' do
      game = Minesweeper.new(33, :hard)
      expect(game).to be_an_instance_of(Minesweeper)
    end
  end

  context '#attempt' do
    let(:minesweeper) { Minesweeper.new(2, :easy) }

    it 'should error when not in progress' do
      allow(minesweeper.game).to receive(:ongoing?).and_return(false)
      expect { minesweeper.attempt(1, 1) }.to output(/Already over!/).to_stdout
    end

    it 'should error when bomb is found' do
      allow(minesweeper.game).to receive(:attempt!).and_raise(BombFoundError.new)
      expect { minesweeper.attempt(1, 1) }.to output(/BOOOOM!/).to_stdout
    end

    it 'should error when coordinates are invalid' do
      allow(minesweeper.game).to receive(:attempt!).and_raise(BoardInvalidCoordinateError.new)
      expect { minesweeper.attempt(1, 1) }.to output(/Invalid coordinate!/).to_stdout
    end

    it 'should succeed if bomb is not found' do
      allow(minesweeper.game).to receive(:attempt!).and_return(123)
      expect { minesweeper.attempt(1, 1) }.to output(/123/).to_stdout
    end
  end

  context '#status' do
    let(:minesweeper) { Minesweeper.new(2, :easy) }

    it 'should error when state is not clear' do
      allow(minesweeper.game).to receive(:ongoing?).and_return(false)
      allow(minesweeper.game).to receive(:won?).and_return(false)
      allow(minesweeper.game).to receive(:lost?).and_return(false)
      expect { minesweeper.status }.to output(/Unknown status/).to_stdout
    end

    it 'should continue when is ongoing' do
      allow(minesweeper.game).to receive(:ongoing?).and_return(true)
      allow(minesweeper.game).to receive(:won?).and_return(false)
      allow(minesweeper.game).to receive(:lost?).and_return(false)
      expect { minesweeper.status }.to output(/Still playing/).to_stdout
    end

    it 'should stop when won' do
      allow(minesweeper.game).to receive(:ongoing?).and_return(false)
      allow(minesweeper.game).to receive(:won?).and_return(true)
      allow(minesweeper.game).to receive(:lost?).and_return(false)
      expect { minesweeper.status }.to output(/You won!/).to_stdout
    end

    it 'should stop when is lost' do
      allow(minesweeper.game).to receive(:ongoing?).and_return(false)
      allow(minesweeper.game).to receive(:won?).and_return(false)
      allow(minesweeper.game).to receive(:lost?).and_return(true)
      expect { minesweeper.status }.to output(/You lost!/).to_stdout
    end
  end

  context '#display' do
    it 'should have 2 columns and rows when size is 2' do
      minesweeper = Minesweeper.new(2, :easy)
      expect { minesweeper.display }.to output(/X X\nX X/).to_stdout
    end

    it 'should have 3 columns and rows when size is 3' do
      minesweeper = Minesweeper.new(3, :easy)
      expect { minesweeper.display }.to output(/X X X\nX X X/).to_stdout
    end
  end
end
# rubocop:enable Metrics/BlockLength
