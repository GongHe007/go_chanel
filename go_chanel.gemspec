# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'go_chanel'
Gem::Specification.new do |spec|
  spec.name          = "go_chanel"
  spec.version       = GoChanel::VERSION
  spec.authors       = ["xuxiangyang"]
  spec.email         = ["xxy@creatingev.com"]
  spec.summary       = %q{simulate golang channel}
  spec.description   = %q{simulate golang channel}
  spec.homepage      = "https://github.com/xuxiangyang/go_chanel"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib/**/"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
