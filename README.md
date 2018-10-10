# DeepDouble

Proper README Coming Soon...

For now, please see the spec file for how to use.

TODO: Motivation
TODO: Compare with RSpec doubles
TODO: Add example use in README

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deep_double'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deep_double

## Usage

See the spec file for more examples.  Here's a basic double:

```ruby
require 'deep_double'

DeepDouble::Double.new(
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
```

## Development

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/deep_double.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
