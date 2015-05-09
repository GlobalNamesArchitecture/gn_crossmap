# GnCrossmap
[![Gem Version][gem_badge]][gem_link]
[![Continuous Integration Status][ci_badge]][ci_link]
[![Coverage Status][cov_badge]][cov_link]
[![CodeClimate][code_badge]][code_link]
[![Dependency Status][dep_badge]][dep_link]

This gem crossmaps a checklist of scientific names to names from a data source
in [GN Resolver][resolver].

Checklist has to be in a CSV format and use semicolon as a separator, '"' as a
field quote.

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

You will be able to compare your checklist with any other data source uploaded
to GN Resolver.

Currently choice of csv formats supported by the gem is limited to
semicolon-separated files with the following Darwin Core Terms:


    taxonID kingdom subkingdom phylum subphylum superclass class subclass
    cohort superorder order suborder infraorder superfamily family subfamily
    tribe subtribe genus subgenus section species subspecies variety form
    scientificNameAuthorship

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

[gem_badge]: https://badge.fury.io/rb/gn_crossmap.png
[gem_link]: http://badge.fury.io/rb/gn_crossmap
[ci_badge]: https://secure.travis-ci.org/GlobalNamesArchitecture/gn_crossmap.png
[ci_link]: http://travis-ci.org/GlobalNamesArchitecture/gn_crossmap
[cov_badge]: https://coveralls.io/repos/GlobalNamesArchitecture/gn_crossmap/badge.png?branch=master
[cov_link]: https://coveralls.io/r/GlobalNamesArchitecture/gn_crossmap?branch=master
[code_badge]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap.png
[code_link]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap
[dep_badge]: https://gemnasium.com/GlobalNamesArchitecture/gn_crossmap.png
[dep_link]: https://gemnasium.com/GlobalNamesArchitecture/gn_crossmap
[resolver]: http://resolver.globalnames.org
[rubygems]: https://rubygems.org
[dimus]: https://github.com/dimus
[mbl]: http://mbl.edu
[license]: https://github.com/GlobalNamesArchitecture/gn_crossmap/blob/master/LICENSE
