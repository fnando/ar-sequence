# frozen_string_literal: true

require "./lib/ar/sequence/version"

Gem::Specification.new do |spec|
  spec.name          = "ar-sequence"
  spec.version       = AR::Sequence::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")
  spec.metadata      = {"rubygems_mfa_required" => "true"}
  spec.summary       = "Add support for PostgreSQL's SEQUENCE on " \
                       "ActiveRecord migrations"
  spec.description   = spec.summary
  spec.homepage      = "https://rubygems.org/gems/ar-sequence"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-fnando"
  spec.add_development_dependency "simplecov"
end
