# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ciserver_formatter/version'

Gem::Specification.new do |gem|
  gem.name          = "ciserver_formatter"
  gem.version       = CiserverFormatter::VERSION
  gem.authors       = ["Diego Alonso"]
  gem.email         = ["diego.alonso@adaptfms.com"]
  gem.description   = %q{Formatter for AdaptFMS CI server}
  gem.summary       = %q{Formatter used when running rspec from the AdaptFMS CI server}
  gem.homepage      = "http://www.gapthemind.net"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('rspec', ["~> 2.0"])
end
