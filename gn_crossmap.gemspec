# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gn_crossmap/version"

Gem::Specification.new do |gem|
  gem.required_ruby_version = ">= 2.1"
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

  gem.files         = `git ls-files -z`.split("\x0").
    reject { |f| f.match(%r{^(test|spec|features)/}) }
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_dependency "trollop", "~> 2.1"
  gem.add_dependency "biodiversity", "~> 3.1"
  gem.add_dependency "rest-client", "~> 1.8"
  gem.add_dependency "logger-colors", "~> 1.0"

  gem.add_development_dependency "bundler", "~> 1.7"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.2"
  gem.add_development_dependency "rubocop", "~> 0.31"
  gem.add_development_dependency "coveralls", "~> 0.8"
end
