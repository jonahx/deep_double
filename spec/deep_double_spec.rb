require 'spec_helper'

RSpec.describe 'DeepDouble' do

  def deep_double(definition)
    DeepDouble::Double.new(definition)
  end

  def literal(value)
    DeepDouble::Literal.new(value)
  end

  context 'with valid unnested definition' do

    subject(:valid) do
      deep_double(
        methA: {
          [] => "methA()",
          [1] => "methA(1)",
          [2] => "methA(2)",
          [1, 2] => "methA(1, 2)",
          [2, 1] => "methA(2, 1)"
        },
        methB: {[] => "methB()"},
        methC: {[{a: 1, b: 2}] => "methC(a: 1, b: 2)"},
        methD: {[] => proc { raise ZeroDivisionError }},
        methE: {[] => -> { raise TypeError }},
      )
    end

    it 'returns correct value for zero args' do
      expect(valid.methA).to eq('methA()')
    end

    it 'handles multiple 0 argument methods' do
      expect(valid.methB).to eq('methB()')
    end

    it 'returns correct value for 1 argument methods' do
      expect(valid.methA(1)).to eq('methA(1)')
    end

    it 'uses the argument to find the correct value' do
      expect(valid.methA(2)).to eq('methA(2)')
    end

    it 'returns correct value for many-argument methods' do
      expect(valid.methA(1, 2)).to eq('methA(1, 2)')
    end

    it 'uses both arguments to find the correct value' do
      expect(valid.methA(2, 1)).to eq('methA(2, 1)')
    end

    it 'works with named arguments' do
      expect(valid.methC(a: 1, b: 2)).to eq('methC(a: 1, b: 2)')
    end

    it 'requires all named arguments to match' do
      expect{ valid.methC(a: 1, b: 3) }.to raise_error(ArgumentError)
    end

    it 'invokes procs when they are specified as the return value' do
      expect{ valid.methD }.to raise_error(ZeroDivisionError)
    end

    it 'invokes lambdas when they are specified as the return value' do
      expect{ valid.methE }.to raise_error(TypeError)
    end

    it 'raises NoMethodError when you call a non-existent method' do
      expect { valid.blah }.to raise_error(NoMethodError)
    end

    it "raises ArgumentError when you haven't configured args" do
      expect { valid.methA(3) }.to raise_error(ArgumentError)
      expect { valid.methA(1, 2, 3) }.to raise_error(ArgumentError)
      expect { valid.methA(1, 3) }.to raise_error(ArgumentError)
    end
  end

  context 'with valid nested definition' do

    subject(:valid) do
      deep_double(
        methA: {
          [] => {
            methAA: {[] => 'methAA()'},
            methAB: {[] => {
              methABA: {[] => 'methABA()'}}
            }
          }
        }
      )
    end

    it 'automatically creates nested DeepDouble instances' do
      expect(valid.methA.methAA).to eq('methAA()')
    end

    it 'handles deep nesting too' do
      expect(valid.methA.methAB.methABA).to eq('methABA()')
    end
  end

  context 'with an invalid definition' do

    let(:invalid_method_name) do
      deep_double(
        methA: {[] => 'methA()'},
        [] => {[] => 'will not work'},
      )
    end

    let(:invalid_result_type) do
      deep_double(methA: 'methA()')
    end

    let(:invalid_result_key) do
      deep_double(methA: {non_array_key: 'methA()'})
    end

    it 'raises when the method name is not a string or symbol' do
      expect{ invalid_method_name }.to raise_error(ArgumentError)
    end

    it 'raises when the result is not a Hash' do
      expect{ invalid_result_type }.to raise_error(ArgumentError)
    end

    it 'raises if a result key is not an array (a list of args)' do
      expect{ invalid_result_key }.to raise_error(ArgumentError)
    end
  end

  context 'when returning literal values' do

    literal_hash = {a: 1}
    literal_proc = -> { raise ArgumentError }

    let(:literal_results) do
      deep_double(
        methA: {[] => literal(literal_hash)},
        methB: {[] => literal(literal_proc)},
      )
    end

    it 'provides a way to return a literal Hash' do
      expect(literal_results.methA).to eq(literal_hash)
    end

    it 'provides a way to return a literal Proc' do
      expect(literal_results.methB).to eq(literal_proc)
    end
  end
end
