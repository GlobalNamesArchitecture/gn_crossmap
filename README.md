# GnCrossmap

[![Gem Version][gem-badge]][gem-link]
[![Continuous Integration Status][ci-badge]][ci-link]
[![Coverage Status][cov-badge]][cov-link]
[![CodeClimate][code-badge]][code-link]
[![Dependency Status][dep-badge]][dep-link]

This gem crossmaps a checklist of scientific names to names from a data source
in [GN Resolver][resolver].

Checklist has to be in a CSV format.

[Issues on waffle.io][waffle]

## Compatibility

This gem is compatible with Ruby versions higher or equal to 2.1.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gn_crossmap'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install gn_crossmap
```

## Usage

### Usage from command line

```bash
# to see help
crossmap --help

# to compare with default source (Catalogue of Life)
crossmap -i my_list.csv -o my_list_col.csv

# to compare with other source (Index Fungorum in this example)
crossmap -i my_list.csv -o my_list_if.csv -d 5

# to use standard intput and/or output
cat my_list.csv | crossmap -i - -o - > output

# to keep only taxonID from original input
cat my_list.csv | crossmap -i my_list.csv -s
```

### Usage as Ruby Library (API description)

#### `GnCrossmap.run`

Compares an input list to a data source from [GN Resolver][resolver] and
writes result into an output file.

```ruby
GnCrossmap.run(input, output, data_source_id, skip_original)
```

``input``
: (string) Either a path to a csv file with list of names, or "-" which
designates `STDIN`

``output``
: (string) Either a path to the output file, or "-" which designates `STDOUT`

``data_source_id``
: (integer) id of a data source from [GN resolver][resolver]

``skip_original``
: (boolean) if true only `taxonID` is preserved from original data. Otherwise
all original data is preserved

#### `GnCrossmap.logger=`

Allows to set logger to a custom logger (default is `STDERR`)

#### Usage Example

```ruby
require "gn_crossmap"

# If you want to change logger -- default Logging is to standard error
GnCrossmap.logger = MyCustomLogger.new

GnCrossmap.run("path/to/input.csv", "path/to/output.csv", 5, true)
```

If you want to get intermediate statistics for each resolution cycle use a
block:

```ruby
GnCrossmap.run("path/to/input.csv", "path/to/output.csv", 5, true) do |stats|
  puts stats
  put "Matches:"
  stats[:matches].each do |key, value|
    puts "#{GnCrossmap::MATCH_TYPES[key]}: #{value}"
  end
end
```

#### Intermediate stats format

|Field           | Description                                             |
|----------------|---------------------------------------------------------|
|total           | total number of names in original list                  |
|current         | number of names already processed                       |
|start_time      | Start of resolution                                     |
|last_batch_time | time span of the last batch processing                  |
|matches         | Distribution of processed data by match type (see below)|

#### Match types

Match types dictionary can be accessed with `GnCrossmap::MATCH_TYPES` constant

| Match code | Match type                       |
|------------|----------------------------------|
|0           |No match                          |
|1           |Exact string match                |
|2           |Canonical form exact match        |
|3           |Canonical form fuzzy match        |
|4           |Partial canonical form match      |
|5           |Partial canonical form fuzzy match|
|6           |Genus part match                  |
|7           |Error in matching                 |

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

#### Types of Matches

The output fomat returns 7 possible types of matches:

1. **Exact string match** - The exact name was matched (but ignoring non-ascii characters)
2. **Exact match by canonical form of a name** - The canonical form of the name (a version of a scientific name that contains complete versions of the latin words, but lacks insertions of subtaxa, annotations, or authority information) was matched
3. **Fuzzy match by canonical form** - The canonical form gave a fuzzy (detecting lexical or spelling variations of a name using Tony Rees' algorithm TAXAMATCH) match
4. **Partial exact match by species part of canonical form** - The canonical form returned a partial but exact match
5. **Partial fuzzy match by species part of canonical form** - The canonical form returned a partial, fuzzy match
6. **Exact match by genus part of a canonical form** - The genus part of the canonical form of the species name returned an exact match
7. **[Blank]** - No match

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org][rubygems]

## Contributing

1. Fork it ( ``https://github.com/[my-github-username]/gn_crossmap/fork`` )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Author -- [Dmitry Mozzherin][dimus]

Copyright (c) 2015-2016 [Marine Biological Laboratory][mbl].
See [LICENSE][license] for details.

[gem-badge]: https://badge.fury.io/rb/gn_crossmap.svg
[gem-link]: http://badge.fury.io/rb/gn_crossmap
[ci-badge]: https://secure.travis-ci.org/GlobalNamesArchitecture/gn_crossmap.svg
[ci-link]: http://travis-ci.org/GlobalNamesArchitecture/gn_crossmap
[cov-badge]: https://coveralls.io/repos/GlobalNamesArchitecture/gn_crossmap/badge.svg?branch=master
[cov-link]: https://coveralls.io/r/GlobalNamesArchitecture/gn_crossmap?branch=master
[code-badge]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap/badges/gpa.svg
[code-link]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap
[dep-badge]: https://gemnasium.com/GlobalNamesArchitecture/gn_crossmap.svg
[dep-link]: https://gemnasium.com/GlobalNamesArchitecture/gn_crossmap
[resolver]: http://resolver.globalnames.org/data_sources
[rubygems]: https://rubygems.org
[dimus]: https://github.com/dimus
[mbl]: http://mbl.edu
[license]: https://github.com/GlobalNamesArchitecture/gn_crossmap/blob/master/LICENSE
[terms]: http://rs.tdwg.org/dwc/terms
[files]:  https://github.com/GlobalNamesArchitecture/gn_crossmap/tree/master/spec/files
[output]: https://github.com/GlobalNamesArchitecture/gn_crossmap/tree/master/spec/files/output-example.csv
[waffle]: https://waffle.io/GlobalNamesArchitecture/gn_crossmap
