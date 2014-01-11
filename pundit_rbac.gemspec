# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pundit_rbac/version'

Gem::Specification.new do |spec|
  spec.name          = "pundit_rbac"
  spec.version       = PunditRbac::VERSION
  spec.authors       = ["John Kamenik"]
  spec.email         = ["jkamenik@gmail.com"]
  spec.description   = %q{Role Based Access Control mixins for Pundit}
  spec.summary       = %q{Pundit Authorization using RBAC}
  spec.homepage      = "https://github.com/jkamenik/pundit_rbac"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'pundit', '~> 0.2.1'
  spec.add_dependency 'activesupport', '>= 3.0.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency "rspec", "~>2.0"
end
