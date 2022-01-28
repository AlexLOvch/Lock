require 'state'
require 'node'
require 'searcher'

describe Searcher do
  describe '#initialize' do
    context 'when init paramai are ok' do
      it "doesn't raise an error" do
        expect { Searcher.new([0, 0], [1, 1]) }.not_to raise_error
        expect { Searcher.new([0, 0], [1, 1], []) }.not_to raise_error
        expect { Searcher.new([0, 0], [1, 1], [[0, 0], [1, 1]]) }.not_to raise_error
      end

      it 'creates and initialize object properly' do
        searcher = Searcher.new([0, 0], [1, 1], [[9, 0], [0, 9]])
        expect(searcher.from).to eq([0, 0])
        expect(searcher.to).to eq([1, 1])
        expect(searcher.excludes).to eq([[9, 0], [0, 9]])
      end
    end

    context 'when wrong init params provided' do
      it 'raises an error' do
        expect { Searcher.new([], [1, 1]) }.to raise_error(Digits::WrongDigitsInitValue)
        expect { Searcher.new('1', [1, 1]) }.to raise_error(Digits::WrongDigitsInitValue)
        expect { Searcher.new('[1, 1]', [1, 1]) }.to raise_error(Digits::WrongDigitsInitValue)
        expect { Searcher.new([1], [1, 1], [[9, 0], [0, 9]]) }.to raise_error(Digits::WrongDigitsLength)
        expect { Searcher.new([0, 1], [1, 1], [[1, 9, 0], [0, 9]]) }.to raise_error(Digits::WrongDigitsLength)
      end
    end
  end

  describe '#search' do
    it 'can find the way if no excludes present' do
      searcher = Searcher.new([0, 0, 0], [1, 2, 3])
      expect(searcher.search).to eq([[0, 0, 0], [1, 0, 0], [1, 1, 0], [1, 2, 0], [1, 2, 1], [1, 2, 2], [1, 2, 3]])
    end

    it 'can find the way if there are excludes' do
      searcher = Searcher.new([0, 0, 0], [1, 2, 3], [[0, 0, 2], [0, 0, 3]])
      expect(searcher.search).to eq([[0, 0, 0], [1, 0, 0], [1, 1, 0], [1, 2, 0], [1, 2, 1], [1, 2, 2], [1, 2, 3]])
    end

    it 'uses shortest way by default' do
      searcher = Searcher.new([0, 0, 0], [9, 8, 7])
      expect(searcher.search).to eq([[0, 0, 0], [9, 0, 0], [9, 9, 0], [9, 8, 0], [9, 8, 9], [9, 8, 8], [9, 8, 7]])
    end

    it 'can find the way even if excludes partically closed shortest direction' do
      searcher = Searcher.new([0, 0], [1, 2], [[0, 1], [1, 0]])
      expect(searcher.search).to eq([[0, 0], [9, 0], [9, 1], [9, 2], [0, 2], [1, 2]])
    end

    it 'can find the way even if excludes totally closed shortest direction' do
      searcher = Searcher.new([0], [2], [[1]])
      expect(searcher.search).to eq([[0], [9], [8], [7], [6], [5], [4], [3], [2]])
    end

    it 'return empty array if no way found' do
      searcher = Searcher.new([0, 0], [2, 2], [[0, 1], [1, 0], [0, 9], [9, 0]])
      expect(searcher.search).to eq('There is NO way to open lock in such conditions!')
    end

    it 'return empty array if to is rejected' do
      searcher = Searcher.new([0, 0], [2, 2], [[2, 2]])
      expect(searcher.search).to eq('There is NO way to open lock in such conditions!')
    end

    it 'return "locker are already opened" if from equal to ' do
      searcher = Searcher.new([0, 0], [0, 0], [[0, 1], [1, 0], [0, 9], [9, 0]])
      expect(searcher.search).to eq('Locker is opened already')
    end
  end
end
