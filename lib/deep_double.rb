# This is a utility class for quickly and declaratively creating doubles of
# arbitrarily nested depth.
#
# It drastically reduces the amount of boilerplate compared with rspec.
#

require 'deep_double/function'
require 'deep_double/literal'
require 'deep_double/recursive_function'
require "deep_double/version"

module DeepDouble
  class Double

    # In this case, having an optional name first makes for a cleaner API
    #
    # rubocop:disable OptionalArguments
    def initialize(name = 'Anonymous', definition)
      @name = name
      @definition = definition
      validate_definition
      create_methods_in_definition
    end
    # rubocop:enable OptionalArguments

    private

    def validate_definition
      @definition.keys.each { |key| validate_method_name(key) }
    end

    def validate_method_name(name)
      return if valid_method_name?(name)
      raise ArgumentError,
        "Method names in DeepDouble definition must be Symbols or Strings. " +
        "The following name is invalid: #{name.inspect}"
    end

    def valid_method_name?(name)
      name.is_a?(Symbol) || name.is_a?(String)
    end

    def create_methods_in_definition
      @definition.keys.each { |meth| create_method(meth) }
    end

    def create_method(meth)
      define_singleton_method(meth.to_sym, &function(meth))
    end

    def function(meth)
      raw_fn = Function.new(@definition[meth])
      RecursiveFunction.new(raw_fn)
    end
  end
end
