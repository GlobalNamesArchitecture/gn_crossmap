require "csv"
require "rest_client"
require "tempfile"
require "logger"
require "logger/colors"
require "biodiversity"
require "gn_crossmap/errors"
require "gn_crossmap/version"
require "gn_crossmap/reader"
require "gn_crossmap/writer"
require "gn_crossmap/collector"
require "gn_crossmap/column_collector"
require "gn_crossmap/sci_name_collector"
require "gn_crossmap/resolver"
require "gn_crossmap/result_processor"

# Namespace module for crossmapping checklists wth GN sources
module GnCrossmap
  class << self
    attr_writer :logger

    def run(input, output, data_source_id)
      input_io, output_io = io(input, output)
      reader = Reader.new(input_io)
      data = reader.read
      writer = Writer.new(output_io, reader.original_fields)
      Resolver.new(writer, data_source_id).resolve(data)
      output
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def log(message)
      logger.info(message)
    end

    private

    def io(input, output)
      fd_i = IO.sysopen(input, "r:utf-8")
      io_in = input.nil? || input == "-" ? stdin : IO.new(fd_i, "r:utf-8")
      fd_o = IO.sysopen(output, "w:utf-8")
      io_out = output.nil? || output == "-" ? STDOUT : IO.new(fd_o, "w:utf-8")
      [io_in, io_out]
    end

    def stdin
      return STDIN if File.file?(STDIN)
      Tempfile.open("stdin") do |temp|
        IO.copy_stream(STDIN, temp)
        STDIN.reopen(temp)
        temp.unlink
      end
    end
  end
end
