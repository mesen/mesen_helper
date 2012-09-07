# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mesen_forms/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kathrin"]
  gem.email         = ["kathrin@mesen.no"]
  gem.description   = %q{Mesen Forms}
  gem.summary       = %q{Mesen Forms}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mesen_forms"
  gem.require_paths = ["lib"]
  gem.version       = MesenForms::VERSION
end