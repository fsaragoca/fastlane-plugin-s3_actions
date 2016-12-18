# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/s3_actions/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-s3_actions'
  spec.version       = Fastlane::S3Actions::VERSION
  spec.author        = %q{Fernando Saragoca}
  spec.email         = %q{fsaragoca@me.com}

  spec.summary       = %q{Download and upload files to AWS S3}
  spec.homepage      = "https://github.com/fsaragoca/fastlane-plugin-s3_actions"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 's3', '~> 0.3.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 2.0.5'
end
