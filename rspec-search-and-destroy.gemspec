# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec-search-and-destroy/version'

Gem::Specification.new do |gem|
  gem.name          = "rspec-search-and-destroy"
  gem.version       = RSpecSearchAndDestroy::VERSION
  gem.authors       = ["Jake Goulding"]
  gem.email         = ["jake.goulding@gmail.com"]
  gem.description   = %q{Finds RSpec test ordering bugs }
  gem.summary       = %q{Finds RSpec test ordering bugs }
  gem.homepage      = "https://github.com/shepmaster/rspec-search-and-destroy"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('rspec', '~> 2.12')

  gem.add_development_dependency('rspec', '~> 2.14')
  gem.add_development_dependency('aruba')
end
