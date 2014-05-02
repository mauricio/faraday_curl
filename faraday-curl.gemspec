# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday/curl/version'

Gem::Specification.new do |spec|
  spec.name          = "faraday_curl"
  spec.version       = Faraday::Curl::VERSION
  spec.authors       = ["Maurício Linhares"]
  spec.email         = ["mauricio.linhares@gmail.com"]
  spec.summary       = %q{Prints CURL compatible commands for the HTTP requests you're making}
  spec.description   = %q{Prints CURL compatible commands for the HTTP requests you're making}
  spec.homepage      = "https://github.com/mauricio/faraday_curl"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 0.9.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'faraday_middleware', ">= 0.9.0"
end
