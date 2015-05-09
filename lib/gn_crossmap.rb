require "csv"
require "rest_client"
require "gn_crossmap/version"
require "gn_crossmap/reader"
require "gn_crossmap/writer"
require "gn_crossmap/data_collector"
require "gn_crossmap/resolver"
require "gn_crossmap/result_processor"

# Namespace module for crossmapping checklists with GN sources
module GnCrossmap
  class << self
    def run(input, output, data_source_id)
      data = Reader.new(input).read
      writer = Writer.new(output)
      Resolver.new(writer, data_source_id).resolve(data)
    end
  end
end
