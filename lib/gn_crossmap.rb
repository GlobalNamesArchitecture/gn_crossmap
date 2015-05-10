require "csv"
require "rest_client"
require "logger"
require "biodiversity"
require "gn_crossmap/version"
require "gn_crossmap/reader"
require "gn_crossmap/writer"
require "gn_crossmap/data_collector"
require "gn_crossmap/resolver"
require "gn_crossmap/result_processor"

# Namespace module for crossmapping checklists wth GN sources
module GnCrossmap
  class << self
    attr_writer :logger

    def run(input, output, data_source_id)
      data = Reader.new(input).read
      writer = Writer.new(output)
      Resolver.new(writer, data_source_id).resolve(data)
      output
    end

    def which_col_sep(path)
      line = open(path, &:readline)
      [";", ",", "\t"].map { |s| [line.count(s), s] }.sort.last.last
    end

    def logger
      @logger ||= Logger.new($stdout)
    end

    def log(message)
      logger.info(message)
    end
  end
end
