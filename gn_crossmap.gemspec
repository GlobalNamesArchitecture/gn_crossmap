# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gn_crossmap/version"

Gem::Specification.new do |gem|
  gem.name          = "gn_crossmap"
  gem.version       = GnCrossmap::VERSION
  gem.authors       = ["Dmitry Mozzherin"]
  gem.email         = ["dmozzherin@gmail.com"]

  gem.summary       = "Crossmaps a list of scientific names to names from " \
                       "a data source in GN Index"
  gem.description   = "User supplies a comma-separated file which breaks " \
                       "contains in one row a hierarchy path of known ranks, " \
                       "scientific name which can be split into its semantic " \
                       "elements and include authorship and taxon concept " \
                       "reference. User also supplies an id of a data source "\
                       "from global names resolver/index. User gets back a " \
                       "new comma-separated file where scientific names from " \
                       "her list match data from the given data source."
  gem.homepage      = "https://github.com/GlobalNamesArchitecture/gn_crossmap"

  gem.files         = `git ls-files -z`.split("\x0").
    reject { |f| f.match(%r{^(test|spec|features)/}) }
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.7"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rubocop", "~> 0.31"
  gem.add_development_dependency "coveralls", "~> 0.8"
end
