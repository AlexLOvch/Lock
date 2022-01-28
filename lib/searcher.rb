require_relative './state'
require_relative './node'

class Searcher
  attr_reader :from, :to, :excludes, :opened, :closed

  def initialize(from, to, excludes = [])
    Digits.validate_list!([from, to])
    Digits.validate_list!(excludes, allow_empty: true, length: from.length)
    @from = from
    @to = to
    @excludes = excludes
    @opened = {}
    node = Node.new(@from, @to, :shortest, nil)
    @opened[node.value] = node
    @closed = {}
  end

  NO_WAY_MESSAGE = 'There is NO way to open lock in such conditions!'
  def search
    return 'Locker is opened already' if @from == @to
    return NO_WAY_MESSAGE if @excludes.include?(@to)

    while @opened.any?
      next_for_open = find_closest
      return get_path(next_for_open) if next_for_open.digits == @to

      open_node(next_for_open)
    end

    NO_WAY_MESSAGE
  end

  private

  def find_closest
    @opened.values.min { |a, b| a.distance <=> b.distance }
  end

  def open_node(node)
    @opened.delete(node.value)
    node.next_nodes(@to, @excludes).each do |next_opened_node|
      unless @opened[next_opened_node.value] || @closed[next_opened_node.value]
        @opened[next_opened_node.value] =
          next_opened_node
      end
    end
    @closed[node.value] = node
  end

  def get_path(node)
    node.parent ? get_path(node.parent) + [node.digits] : [node.digits]
  end
end
