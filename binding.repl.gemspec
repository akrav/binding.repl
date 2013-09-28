# coding: utf-8
require "./lib/binding.repl"
Gem::Specification.new do |spec|
  spec.name          = "binding.repl"
  spec.version       = Binding.repl.version
  spec.authors       = ["Robert Gleeson"]
  spec.email         = ["rob@flowof.info"]
  spec.description   = "binding.repl: binding.pry for all ruby consoles"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/robgleeson/binding.repl"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 1.9.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
