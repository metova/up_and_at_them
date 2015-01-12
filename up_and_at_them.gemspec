# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'up_and_at_them/version'

Gem::Specification.new do |spec|
  spec.name          = "up_and_at_them"
  spec.version       = UpAndAtThem::VERSION
  spec.authors       = ["Dave Lane"]
  spec.email         = ["dave.lane@metova.com"]
  spec.summary       = 'A library for simplifying atomic transactions.'
  spec.description   = 'A library for simplifying atomic transactions with the option for rollback of each operation in the transaction.'
  spec.homepage      = "http://github.com/metova/up_and_at_them"
  spec.license       = "Apache"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

end
