Dir['./lib/*.rb'].each { |file| require file }
require 'optparse'

class Optparser
  class ScriptOptions
    attr_accessor :from, :to, :excludes

    def define_options(parser)
      parser.banner = 'Usage: unlock.rb [options]'
      parser.separator ''
      parser.separator 'Specific options:'

      parser.on('-f', '--from FROM_COMBINATION', Array, 'From combination. Mandatory. Example: -f 0,0,0') do |from|
        self.from = from
      end

      parser.on('-t', '--to TO_COMBINATION', Array, 'To combination. Mandatory. Example: -to 1,2,3') do |to|
        self.to = to
      end

      parser.on('-e', '--excludes EXCLUDES_ARRAY',
                "List of excluded combinations. Optional. Example: -e '[[1,2,1],[4,6,1]]'") do |e|
        self.excludes = e
      end

      parser.separator ''
      parser.separator 'Common options:'

      parser.on_tail('-h', '--help', 'Show this message') do
        puts parser
        exit
      end
    end
  end

  def parse(args)
    @options = ScriptOptions.new
    @args = OptionParser.new do |parser|
      @options.define_options(parser)
      parser.parse!(args)
    end
    @options
  end

  attr_reader :parser, :options
end

options = Optparser.new.parse(ARGV)
unless options.from || options.to
  puts 'There is empty --from or -- to option. Run unlock with -h to check format and try again'
  exit
end
searcher = nil
begin
  from = Digits.digits_from_strings_array(options.from)
  to = Digits.digits_from_strings_array(options.to)
  excludes = Digits.list_from_string(options.excludes) if options.excludes
  searcher = Searcher.new(from, to, excludes)
rescue Digits::DigitsValidationError
  puts 'There is an error in input options. Run unlock with -h to check format and try again'
  exit
end

begin
  search_results = searcher.search
  puts(search_results.inspect)
rescue StandardError
  puts 'Something goes wrong. Pls contact us for help.'
end
