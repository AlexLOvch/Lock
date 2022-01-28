require_relative './digits'

class State
  attr_accessor :digits
  attr_reader :length, :value

  def initialize(digits)
    Digits.validate!(digits)

    @digits = digits
    @length = digits.size
    @value = digits.join.to_i
  end

  def to_s
    digits.join
  end

  def distances(another_state_or_digits, direction = :shortest)
    another_state = another_state_or_digits.is_a?(State) ? another_state_or_digits : State.new(another_state_or_digits)

    digits.each_with_index.map do |digit, i|
      digits_distance(digit, another_state.digits[i], direction)
    end
  end

  def distances_length(another_state, direction = :shortest)
    distances(another_state, direction).sum(&:abs)
  end

  def directions_to(another_state, direction = :shortest)
    distances(another_state, direction).map { |d| d <=> 0 }
  end

  def next_states_to(another_state, direction = :shortest)
    states = []
    directions_to(another_state, direction).each_with_index do |addition, i|
      next unless addition != 0

      new_digits = digits.dup
      new_digits[i] = limit_digit(new_digits[i] + addition)
      states << State.new(new_digits)
    end
    states
  end

  private

  def digits_distance(d1, d2, direction)
    return 0 if d1 == d2

    diff = d2 - d1
    distance = diff.abs <= 5 ? diff : (10 - diff.abs) * (-diff <=> 0)
    distance = (10 - distance.abs) * (-distance <=> 0)  unless direction == :shortest
    distance
  end

  def limit_digit(d)
    return 0 if d > 9
    return 9 if d < 0

    d
  end
end
