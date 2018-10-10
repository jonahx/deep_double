
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "deep_double/version"

Gem::Specification.new do |spec|
  spec.name          = "deep_double"
  spec.version       = DeepDouble::VERSION
  spec.authors       = ["Jonah"]
  spec.email         = ["jonahx@gmail.com"]

  spec.summary       = %q{Fast, declarative test doubles that support nesting.}
  spec.homepage      = "https://github.com/jonahx/deep_double"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
