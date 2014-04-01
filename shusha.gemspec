# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shusha/version'

Gem::Specification.new do |spec|
  spec.name          = 'shusha'
  spec.version       = Shusha::VERSION::STRING
  spec.authors       = ['Andrey Kopylov']
  spec.email         = ['elymse@gmail.com']
  spec.summary       = %q{Game development framework}
#  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-core'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'rspec-expectations'
  spec.add_development_dependency 'gamebox'

  spec.add_dependency 'gosu'
  spec.add_dependency 'require_all'
  spec.add_dependency 'listen'
  spec.add_dependency 'activerecord'
  spec.add_dependency 'activemodel'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'thor'

end
