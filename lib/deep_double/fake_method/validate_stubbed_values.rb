# Validates that the structure of a stubbed values Hash is valid:
# - It must be a Hash
# - It's keys must be Arrays or the special value ":default"
#
module DeepDouble
  class FakeMethod

    class ValidateStubbedValues
      def initialize(stubbed_values)
        @stubbed_values = stubbed_values
      end

      def call
        validate_type
        validate_keys
      end

      private

      def validate_type
        return if @stubbed_values.is_a?(Hash)
        raise ArgumentError,
          "The stubbed values defining a FakeMethod must be a Hash"
      end

      def validate_keys
        @stubbed_values.keys.each { |key| validate_key(key) }
      end

      def validate_key(key)
        return if valid_key?(key)
        raise ArgumentError,
          "Keys in a stubbed values Hash must by Arrays representing " +
          "argument lists (the empty array represents 0 arguments). The " +
          "following key was invalid: #{key.inspect}"
      end

      def valid_key?(key)
        key.is_a?(Array) || key == :default
      end
    end

  end
end
