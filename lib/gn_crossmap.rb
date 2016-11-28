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
  INPUT_MODE = "r:utf-8".freeze
  OUTPUT_MODE = "w:utf-8".freeze
  MATCH_TYPES = {
    0 => "No match",
    1 => "Exact string match",
    2 => "Canonical form exact match",
    3 => "Canonical form fuzzy match",
    4 => "Partial canonical form match",
    5 => "Partial canonical form fuzzy match",
    6 => "Genus part match",
    7 => "Error in matching"
  }.freeze

  class << self
    attr_writer :logger

    def run(input, output, data_source_id, skip_original)
      input_io, output_io = io(input, output)
      reader = Reader.new(input_io, input_name(input), skip_original)
      data = reader.read
      writer = Writer.new(output_io, reader.original_fields,
                          output_name(output))
      resolver = Resolver.new(writer, data_source_id)
      block_given? ? resolver.resolve(data, &Proc.new) : resolver.resolve(data)
      output
    end

    def logger
      @logger ||= Logger.new(STDERR)
    end

    def log(message)
      logger.info(message)
    end

    private

    def io(input, output)
      io_in = iogen(input, INPUT_MODE)
      io_out = iogen(output, OUTPUT_MODE)
      [io_in, io_out]
    end

    def iogen(arg, mode)
      if arg.nil? || arg == "-"
        mode == INPUT_MODE ? stdin : STDOUT
      else
        fd_i = IO.sysopen(arg, mode)
        IO.new(fd_i, mode)
      end
    end

    def stdin
      temp = Tempfile.open("stdin")
      return STDIN if File.file?(STDIN)
      IO.copy_stream(STDIN, temp)
      fd_i = IO.sysopen(temp, INPUT_MODE)
      IO.new(fd_i, INPUT_MODE)
    end

    def input_name(input)
      input.nil? || input == "-" ? "STDIN" : input
    end

    def output_name(output)
      output.nil? || output == "-" ? "STDOUT" : output
    end
  end
end
