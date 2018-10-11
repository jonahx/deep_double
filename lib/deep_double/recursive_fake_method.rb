# Makes a `DeepDouble::FakeMethod` recursive, so that `Hash` results are
# automatically converted to `DeepDouble` instances in their own right.
#
module DeepDouble
  class RecursiveFakeMethod

    def initialize(fake_method)
      @fake_method = fake_method
    end

    def call(*args)
      result = @fake_method.call(*args)
      special_case_transforms(result)
    end

    def to_proc
      method(:call).to_proc
    end

    private

    def special_case_transforms(result)
      class_name = result.class.name.split('::').last
      case class_name
      when 'Hash'
        Double.new(result) # recursive case
      when 'Proc'
        result.call
      when 'Literal'
        result.value
      else
        result
      end
    end
  end
end
