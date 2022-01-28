require 'digits'
require 'state'

describe State do
  let(:state_000) { State.new([0, 0, 0]) }
  let(:state_123) { State.new([1, 2, 3]) }
  let(:state_789) { State.new([7, 8, 9]) }
  let(:state_059) { State.new([0, 5, 9]) }

  describe '#initialize' do
    let(:correct_init_value) { [0, 1, 2] }
    let(:wrong_init_values) { [1, '1,1,1', ['0', 1, 2]] }

    context 'when init param is ok' do
      it "doesn't raise an error" do
        expect { State.new(correct_init_value) }.not_to raise_error
      end

      it 'creates and initialize object properly' do
        state = State.new(correct_init_value)
        expect(state.value).to eq 12
        expect(state.to_s).to eq '012'
        expect(state.length).to eq 3
      end
    end

    context 'when wrong init param provided' do
      it 'raises an error' do
        wrong_init_values.each do |v|
          expect { State.new(v) }.to raise_error(Digits::WrongDigitsInitValue)
        end
      end
    end
  end

  describe 'distances' do
    it 'should calculate distances correctly' do
      expect(state_000.distances(state_123)).to eq([1, 2, 3])
      expect(state_123.distances(state_000)).to eq([-1, -2, -3])
      expect(state_000.distances(state_789)).to eq([-3, -2, -1])
      expect(state_123.distances(state_789)).to eq([-4, -4, -4])
      expect(state_000.distances(state_059)).to eq([0, 5, -1])
      expect(state_000.distances(state_059, :longest)).to eq([0, -5, 9])
    end

    it 'should calculate distances_length correctly' do
      expect(state_000.distances_length(state_059)).to eq 6
      expect(state_000.distances_length(state_059, :longest)).to eq 14
    end

    it 'should calculate directions_to correctly' do
      expect(state_000.directions_to(state_059)).to eq([0, 1, -1])
      expect(state_000.directions_to(state_059, :longest)).to eq([0, -1, 1])
    end
  end

  describe '#next_states_to' do
    it 'should calculate next states in the right direction correctly' do
      expect(state_000.next_states_to(state_000).map(&:to_s)).to eq([])
      expect(state_000.next_states_to(state_123).map(&:to_s)).to eq(%w[100 010 001])
      expect(state_000.next_states_to(state_059).map(&:to_s)).to eq(%w[010 009])
      expect(state_000.next_states_to(state_059, :longest).map(&:to_s)).to eq(%w[090 001])
    end
  end
end
