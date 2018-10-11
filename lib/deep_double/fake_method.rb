require 'deep_double/fake_method/validate_stubbed_values'

# Takes a Hash of stubbed values to create a fake method. The stubbed values map
# lists of arguments (represented as arrays, with the empty array representing a
# method that takes no args) to return values.
#

module DeepDouble
  class FakeMethod

    def initialize(stubbed_values)
      @stubbed_values = stubbed_values
      validate_stubbed_values
    end

    def call(*args)
      result(args)
    end

    private

    def validate_stubbed_values
      ValidateStubbedValues.new(@stubbed_values).call
    end

    def result(args)
      validate_result_exists(args)
      @stubbed_values.key?(args) ? @stubbed_values[args] : @stubbed_values[:default]
    end

    def validate_result_exists(args)
      return if result_exists?(args)
      raise ArgumentError, "FakeMethod not defined for args: #{args}"
    end

    def result_exists?(args)
      @stubbed_values.key?(args) || @stubbed_values.key?(:default)
    end
  end
end
