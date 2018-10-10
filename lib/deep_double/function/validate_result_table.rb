# A "function" in the mathematical sense: a mapping of input values to output
# values.  This (argument -> value) mapping is specified by a "result_table" --
# just an ordinary ruby hash -- passed to the constructor.
#
# If the return value is itself a hash, it's interpreted as the definition of
# another double, and so another `DeepDouble` instance is returned.
#
module DeepDouble
  class Function

    class ValidateResultTable
      def initialize(result_table)
        @result_table = result_table
      end

      def call
        validate_result_table_type
        validate_result_table_keys
      end

      private

      def validate_result_table_type
        return if @result_table.is_a?(Hash)
        raise ArgumentError,
          "The result table defining a Function must be a Hash"
      end

      def validate_result_table_keys
        @result_table.keys.each { |key| validate_key(key) }
      end

      def validate_key(key)
        return if valid_key?(key)
        raise ArgumentError,
          "Keys in a result table must by Arrays representing argument " +
          "lists (the empty array represents 0 arguments). The following " +
          "key was invalid: #{key.inspect}"
      end

      def valid_key?(key)
        key.is_a?(Array) || key == :default
      end
    end

  end
end
