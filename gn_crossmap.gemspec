# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gn_crossmap/version"

Gem::Specification.new do |spec|
  spec.name          = "gn_crossmap"
  spec.version       = GnCrossmap::VERSION
  spec.authors       = ["Dmitry Mozzherin"]
  spec.email         = ["dmozzherin@gmail.com"]

  spec.summary       = "Crossmaps a list of scientific names to names from " \
                       "a data source in GN Index"
  spec.description   = "User supplies a comma-separated file which breaks " \
                       "contains in one row a hierarchy path of known ranks, " \
                       "scientific name which can be split into its semantic " \
                       "elements and include authorship and taxon concept " \
                       "reference. User also supplies an id of a data source "\
                       "from global names resolver/index. User gets back a " \
                       "new comma-separated file where scientific names from " \
                       "her list match data from the given data source."
  spec.homepage      = "https://github.com/GlobalNamesArchitecture/gn_crossmap"

  spec.files         = `git ls-files -z`.split("\x0").
    reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", "~> 0.31"
  gem.add_development_dependency "coveralls", "~> 0.8", require: false
end
