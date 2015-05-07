# GnCrossmap
[![Gem Version][gem_badge]][gem_link]
[![Continuous Integration Status][ci_badge]][ci_link]
[![Coverage Status][cov_badge]][cov_link]
[![CodeClimate][code_badge]][code_link]
[![Dependency Status][dep_badge]][dep_link]

This gem crossmaps a list of scientific names to names from a data source in GN
Index

User supplies a comma-separated file which breaks contains in one row a
hierarchy path of known ranks, scientific name which can be split into its
semantic elements and include authorship and taxon concept reference. User also
supplies an id of a data source from global names resolver/index. User gets
back a new comma-separated file where scientific names from her list match data
from the given data source.

Compatibility
-------------

This gem is compatible with Ruby >= 2.1.0

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

[rubygems]: https://rubygems.org
[dimus]: https://github.com/dimus
[mbl]: http://mbl.edu
[license]:
[gem_badge]: https://badge.fury.io/rb/gn_crossmap.png
[gem_link]: http://badge.fury.io/rb/gn_crossmap
[ci_badge]: https://secure.travis-ci.org/GlobalNamesArchitecture/gn_crossmap.png
[ci_link]: http://travis-ci.org/GlobalNamesArchitecture/gn_crossmap
[cov_badge]: https://coveralls.io/repos/GlobalNamesArchitecture/gn_crossmap/badge.png
[cov_link]: https://coveralls.io/r/GlobalNamesArchitecture/gn_crossmap
[code_badge]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap.png
[code_link]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap
[dep_badge]: https://gemnasium.com/GlobalNamesArchitecture/gn_crossmap.png
[dep_link]: https://gemnasium.com/GlobalNamesArchitecture/gn_crossmap
