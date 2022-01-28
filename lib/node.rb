require_relative './digits'
require_relative './state'

class Node
  attr_reader :state, :parent, :distance

  def initialize(digits, to_digits, direction, parent)
    Digits.validate_list!([digits, to_digits])
    from_state = State.new(digits)
    @state = from_state
    @parent = parent
    @distance = from_state.distances_length(to_digits, direction)
  end

  def next_nodes(to_digits, excludes_digits)
    next_nodes_to_direction(to_digits, excludes_digits, :shortest) +
      next_nodes_to_direction(to_digits, excludes_digits, :longest)
  end

  # TODO: USE DELEGATOR
  def value
    @state.value
  end

  def digits
    @state.digits
  end

  private

  def next_nodes_to_direction(to_digits, excludes_digits, direction)
    states = @state.next_states_to(to_digits, direction).reject { |s| excludes_digits.include?(s.digits) }
    states.map { |s| Node.new(s.digits, to_digits, direction, self) }
  end
end
