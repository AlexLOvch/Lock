require 'json'

class Digits
  class DigitsValidationError < StandardError; end
  class WrongDigitsInitValue < DigitsValidationError; end
  class WrongDigitsLength < DigitsValidationError; end

  class << self
    def digits_from_strings_array(arr)
      arr.map { |digit| digit.to_i }
    rescue StandardError
      raise WrongDigitsInitValue
    end

    def list_from_string(str)
      JSON.parse(str)
    rescue StandardError
      raise WrongDigitsInitValue
    end

    def validate_list!(digits_list, params = {})
      allow_empty = params[:allow_empty]
      length = params[:length]

      digits_list.each { |digits| validate!(digits, params) }

      return if allow_empty && digits_list.empty?

      raise WrongDigitsLength unless equal_sizes?(digits_list)
      raise WrongDigitsLength if length && !sizes_equal_to(digits_list, length)
    end

    def validate!(digits, params = {})
      allow_empty = params[:allow_empty]
      unless digits.is_a?(Array) && ((allow_empty && digits.empty?) || (digits.any? && digits_array_correct?(digits)))
        raise WrongDigitsInitValue
      end
    end

    def digits_array_correct?(digits_arr)
      digits_arr.all? do |digit|
        digit.is_a?(Integer) && digit.between?(0, 9)
      end
    end

    def sizes_equal_to(arrays, length)
      sizes(arrays) == [length]
    end

    def equal_sizes?(arrays)
      sizes(arrays).length == 1
    end

    def sizes(arrays)
      arrays.map(&:length).uniq
    end
  end
end
