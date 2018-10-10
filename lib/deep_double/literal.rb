# Because a Hash in the context of a DeepDouble definition is considered to be
# the definition of a *nested* DeepDouble, we need a way to "escape" a Hash for
# methods that actually return Hash values.
#
# Likewise, a Proc in the context of a DeepDouble definition is invoked
# automatically. (This lets us, eg, create methods that raise errors.)  Again,
# we need a way to "escape" a Proc for methods that actually return literal
# Proc values.
#
# This class provides a general mechanism to "escape" special values in
# Function definitions.
#
module DeepDouble
  class Literal
    attr_reader :value

    def initialize(value)
      @value = value
    end
  end
end
