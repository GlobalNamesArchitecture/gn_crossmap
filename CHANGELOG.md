# ``gn_crossmap`` CHANGELOG

## 0.2.1

* @dimus - fixes in failing tests

## 0.2.0

* @dimus - #17 - change in API - use of STDIN and STDOUT for input and output

## 0.1.8

* @dimus - #14 - show synonym status

## 0.1.7

* @dimus - #13 - make it possible wo ingest field names like dwc:scientificName
                 or ``http://example.org/term/sommeTerm``

* @dimus - #12 - fix a bug which prevents so salvage most of the names from a
                 failing batch (if a batch of names has one name that breaks
                 resolution on GN-resolver end)

* @dimus - #11 - add taxonID from resolved data to results

* @dimus - #10 - in resulting csv moved "match_type" field to be the first one
                 to make it easier to see what matched and what did not

* @dimus - #9 - fixed another problem with rank inffering

## 0.1.6

* @dimus - #8 - catching "No Method Found" exception at inferring rank

## 0.1.5

* @dimus - #5 - All original fields are now preserved in the output file.

* @dimus - #3 - If ingest has more than 10K rows -- user will see logging events

* @dimus - #4 Bug - Add error messages if headers don't have necessary fields

* @dimus - #2 - Header fields are now allowed to have trailing spaces

* @dimus - #7 Bug - Empty rank does not break crossmapping anymore

* @dimus - #1 Bug - Add missing rest-client gem

## 0.1.4

* @dimus - Bug fixes

## 0.1.3

* @dimus - README and gemspec changes

## 0.1.2

* @dimus - clean up docs, and remove junk code

## 0.1.1

* @dimus - first official release -- works for full names
                              and names entered in rank fields

## 0.1.0

* @dimus - initial version
