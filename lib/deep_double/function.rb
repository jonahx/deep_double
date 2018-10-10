require 'deep_double/function/validate_result_table'

# A "function" in the mathematical sense: a mapping of input values to output
# values.  This (argument -> value) mapping is specified by a "result_table" --
# just an ordinary ruby hash -- passed to the constructor.
#
# If the return value is itself a hash, it's interpreted as the definition of
# another double, and so another `DeepDouble` instance is returned.
#
module DeepDouble
  class Function

    def initialize(result_table)
      @result_table = result_table
      validate_result_table
    end

    def call(*args)
      validate_result_exists(args)
      result(args)
    end

    private

    def validate_result_table
      ValidateResultTable.new(@result_table).call
    end

    def validate_result_exists(args)
      return if value_defined_for?(args)
      raise ArgumentError, "Function not defined for args: #{args}"
    end

    def result(args)
      if @result_table.key?(args)
        @result_table[args]
      else
        @result_table[:default]
      end
    end

    def value_defined_for?(args)
      @result_table.key?(args) || @result_table.key?(:default)
    end
  end
end
