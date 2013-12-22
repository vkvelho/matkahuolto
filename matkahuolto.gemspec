# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'matkahuolto/version'

Gem::Specification.new do |spec|
  spec.name          = "matkahuolto"
  spec.version       = Matkahuolto::VERSION
  spec.authors       = ["Ilkka Sopanen"]
  spec.email         = ["ilkka.sopanen@gmail.com"]
  spec.summary       = %q{Get the nearest delivery points from Matkahuolto.}
  spec.description   = %q{Just give him a valid Finnish address and he'll give you the nearest delivery points as an array of hashes.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
