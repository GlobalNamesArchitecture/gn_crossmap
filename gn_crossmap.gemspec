# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gn_crossmap/version"

# rubocop:disable Metrics/BlockLength:

Gem::Specification.new do |gem|
  gem.required_ruby_version = ">= 2.4"
  gem.name          = "gn_crossmap"
  gem.version       = GnCrossmap::VERSION
  gem.license       = "MIT"
  gem.authors       = ["Dmitry Mozzherin"]
  gem.email         = ["dmozzherin@gmail.com"]

  gem.summary       = "Crossmaps a list of scientific names to names from " \
                      "a data source in GN Index"
  gem.description   = "Gem uses a checklist in a comma-separated format as " \
                      "an input, and returns back a new comma-separated " \
                      "list crossmapping the scientific names to one of the " \
                      "data sources from http://resolver.globalnames.org"
  gem.homepage      = "https://github.com/GlobalNamesArchitecture/gn_crossmap"

  gem.files         = `git ls-files -z`.
                      split("\x0").
                      reject { |f| f.match(%r{^(test|spec|features)/}) }
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_dependency "biodiversity", "~> 3.5"
  gem.add_dependency "concurrent-ruby", "~> 1.0"
  gem.add_dependency "gn_uuid", "~> 0.5"
  gem.add_dependency "logger-colors", "~> 1.0"
  gem.add_dependency "rest-client", "~> 2.0"
  gem.add_dependency "optimist", "~> 3.0"

  gem.add_development_dependency "bundler", "~> 1.16"
  gem.add_development_dependency "byebug", "~> 10.0"
  gem.add_development_dependency "coveralls", "~> 0.8"
  gem.add_development_dependency "rake", "~> 12.3"
  gem.add_development_dependency "rspec", "~> 3.8"
  gem.add_development_dependency "rubocop", "~> 0.59"
end

# rubocop:enable Metrics/BlockLength:
