require "csv"
require "gn_crossmap/version"
require "gn_crossmap/reader"
require "gn_crossmap/writer"
require "gn_crossmap/data_collector"
require "gn_crossmap/resolver"
require "gn_crossmap/result_processor"

# Namespace module for crossmapping checklists with GN sources
module GnCrossmap
  def self.run(input, output, data_source_id)
    data = Reader.new(input).read
    Resolver.new(ouput, data_source_id).resolve(data)
  end
end
