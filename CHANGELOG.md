# ``gn_crossmap`` CHANGELOG

## 3.1.3

* @dimus - Fix formatting bug for empty results, remove BOM char from headers

## 3.1.2

* @dimus - Fixes #37 tab is now default if separator is not found

## 3.1.1

* @dimus - Fixes #36 move edit distance close to canonical forms in output

## 3.1.0

* @dimus - Fixes #34 add canonical form input

* @dimus - Fixes #35 optionally returns classification path

## 3.0.3

* @dimus - Fixes #33 infraspecies rank is given for all 'unknown' infra-specific
           ranks (when rank is not given)

* @dimus - Fixes #32 normalize capitalization of ranks according to Codes

## 3.0.2

* @dimus - Fixes #32 normalize capitalization of ranks according to Codes

## 3.0.1

* @dimus - fixes #31 bug: prevent csv row to get  squashed
           when original or alternative headers are not unique to each other

## 3.0.0

* @dimus - allow lists without taxonID

## 2.3.1

* @dimus - show resolver url in log

## 2.3.0

* @dimus - add option to supply url for global names resolver

## 2.2.3

* @dimus - make csv processing more permissive, continue
           it after meeting malformed csv rows. Add "errors"
           field into status report.

## 2.1.3

* @dimus - fix nil situation in headers' fields

## 2.1.2

* @dimus - fix recognition of taxonID with traling space

## 2.1.1

* @dimus - fix stats for ingestion

## 2.1.0

* @dimus - #27 terminate resolution by a trigger

## 2.0.0

* @dimus - #26 change GnCrossmap.run to take opts parameter

## 1.3.0

* @dimus - #25 add `alt_headers` parameter

## 1.2.2

* @dimus - fix `resolution_stop` and final status in stats

## 1.2.1

* @dimus - Add `resolution_stop` field for stats

## 1.2.0

* @dimus - #24 optional block for GnCrossmap.run now also gives access to
           intermediate results of CSV file reading

## 1.1.0

* @dimus - #23 optional block for GnCrossmap.run gives access to intermediate
           results

## 1.0.0

* @dimus - #18 output file optionally removes original fields except `taxonID`

* @dimus - #19 `acceptedName` field if filled for all matched names

* @dimus - #22 output is now tab-separated instead of comma-separated

## 0.2.2

* @dimus - gem update

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

* @dimus - #10 - in resulting csv moved ``match_type`` field to be the first one
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
