# GnCrossmap
[![Gem Version][gem_badge]][gem_link]
[![Continuous Integration Status][ci_badge]][ci_link]
[![Coverage Status][cov_badge]][cov_link]
[![CodeClimate][code_badge]][code_link]
[![Dependency Status][dep_badge]][dep_link]

This gem crossmaps a checklist of scientific names to names from a data source
in [GN Resolver][resolver].

Checklist has to be in a CSV format.

Compatibility
-------------

This gem is compatible with Ruby versions higher or equal to 2.1.0

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'gn_crossmap'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gn_crossmap

Usage
-----

### Input file format

- Comma Separated File with names of fields in first row.
- Columns can be separated by **tab**, **comma** or **semicolon**
- At least some columns should have recognizable fields

`taxonID` `kingdom` `phylum` `class` `order` `family` `genus` `species`
`subspecies` `variety` `form scientificNameAuthorship` `scientificName`
`taxonRank`

#### Simple Example

    taxonID;scientificName
    1;Macrobiotus echinogenitus subsp. areolatus Murray, 1907
    ...

|taxonID | scientificName                                          |
|--------|---------------------------------------------------------|
|1       | Animalia                                                |
|2       | Macrobiotus echinogenitus subsp. areolatus Murray, 1907 |

#### Rank Example

    taxonID;scientificName;taxonRank
    1;Macrobiotus echinogenitus f. areolatus Murray, 1907;form
    ...

|taxonID | scientificName                                          | taxonRank |
|--------|---------------------------------------------------------|-----------|
|1       | Animalia                                                | kingdom   |
|2       | Macrobiotus echinogenitus subsp. areolatus Murray, 1907 | subspecies|

#### Family and Authorship Example

    taxonID;family;scientificName;scientificNameAuthorship
    1;Macrobiotidae;Macrobiotus echinogenitus subsp. areolatus;Murray, 1907
    ...

|taxonID | family        | scientificName            | scientificNameAuthorship|
|--------|---------------|---------------------------|-------------------------|
|1       |               | Animalia                  |                         |
|2       | Macrobiotidae | Macrobiotus echinogenitus | Murray                  |

#### Fine-grained Example

    TaxonId;kingdom;subkingdom;phylum;subphylum;superclass;class;subclass;cohort;superorder;order;suborder;infraorder;superfamily;family;subfamily;tribe;subtribe;genus;subgenus;section;species;subspecies;variety;form;ScientificNameAuthorship
    1;Animalia;;Tardigrada;;;Eutardigrada;;;;Parachela;;;Macrobiotoidea;Macrobiotidae;;;;Macrobiotus;;;harmsworthi;obscurus;;;Dastych, 1985


TaxonId|kingdom|subkingdom|phylum|subphylum|superclass|class|subclass|cohort|superorder|order|suborder|infraorder|superfamily|family|subfamily|tribe|subtribe|genus|subgenus|section|species|subspecies|variety|form|ScientificNameAuthorship
-------|-------|----------|------|---------|----------|-----|--------|------|----------|-----|--------|----------|-----------|------|---------|-----|--------|-----|--------|-------|-------|----------|-------|----|------------------------
136021|Animalia||Pogonophora||||||||||||||||||||||
136022|Animalia||Pogonophora|||Frenulata|||||||||||||||||||Webb, 1969
565443|Animalia||Tardigrada|||Eutardigrada||||Parachela|||Macrobiotoidea|Macrobiotidae||||Macrobiotus|||harmsworthi|obscurus|||Dastych, 1985

More examples can be found in [spec/files][files] directory

### Output file format

[Output][output] includes following fields:

Field                | Description
---------------------|-----------------------------------------------------------
taxonID              | original ID attached to a name in the checklist
scientificName       | name from the checklist
matchedScientificName| name matched from the GN Reolver data source
matchedCanonicalForm | canonical form of the matched name
rank                 | rank from the source (if it was given/inferred)
matchedRank          | corresponding rank from the data source
matchType            | what kind of match it is
editDistance         | for fuzzy-matching -- how many characters differ between checklist and data source name
score                | heuristic score from 0 to 1 where 1 is a good match, 0.5 match requires further human investigation

### Usage from command line

    # to see help
    $ crossmap --help

    # to compare with default source (Catalogue of Life)
    $ crossmap -i my_list.csv -o my_list_col.csv

    # to compare with other source (Index Fungorum in this example)
    $ crossmap -i my_list.csv -o my_list_if.csv -d 5

### Usage as Ruby Library

```ruby
require "gn_crossmap"

# If you want to change logger -- default Logging is to standard output
GnCrossmap.logger = MyCustomLogger.new

GnCrossmap.run("path/to/input.csv", "path/to/output.csv", 5)
```

Development
-----------

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org][rubygems]

Contributing
------------

1. Fork it ( https://github.com/[my-github-username]/gn_crossmap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Copyright
---------

Author -- [Dmitry Mozzherin][dimus]

Copyright (c) 2015 [Marine Biological Laboratory][mbl].
See [LICENSE][license] for details.

[gem_badge]: https://badge.fury.io/rb/gn_crossmap.svg
[gem_link]: http://badge.fury.io/rb/gn_crossmap
[ci_badge]: https://secure.travis-ci.org/GlobalNamesArchitecture/gn_crossmap.svg
[ci_link]: http://travis-ci.org/GlobalNamesArchitecture/gn_crossmap
[cov_badge]: https://coveralls.io/repos/GlobalNamesArchitecture/gn_crossmap/badge.svg?branch=master
[cov_link]: https://coveralls.io/r/GlobalNamesArchitecture/gn_crossmap?branch=master
[code_badge]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap/badges/gpa.svg
[code_link]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap
[dep_badge]: https://gemnasium.com/GlobalNamesArchitecture/gn_crossmap.png
[dep_link]: https://gemnasium.com/GlobalNamesArchitecture/gn_crossmap
[resolver]: http://resolver.globalnames.org/data_sources
[rubygems]: https://rubygems.org
[dimus]: https://github.com/dimus
[mbl]: http://mbl.edu
[license]: https://github.com/GlobalNamesArchitecture/gn_crossmap/blob/master/LICENSE
[terms]: http://rs.tdwg.org/dwc/terms
[files]:  https://github.com/GlobalNamesArchitecture/gn_crossmap/tree/master/spec/files
[output]: https://github.com/GlobalNamesArchitecture/gn_crossmap/tree/master/spec/files/output-example.csv
