# frozen_string_literal: true

require "csv"
require "ostruct"
require "rest_client"
require "tempfile"
require "logger"
require "logger/colors"
require "biodiversity"
require "concurrent"
require "gn_uuid"
require "gn_crossmap/errors"
require "gn_crossmap/version"
require "gn_crossmap/resolver_job"
require "gn_crossmap/reader"
require "gn_crossmap/writer"
require "gn_crossmap/collector"
require "gn_crossmap/column_collector"
require "gn_crossmap/sci_name_collector"
require "gn_crossmap/resolver"
require "gn_crossmap/result_processor"
require "gn_crossmap/stats"

# Namespace module for crossmapping checklists wth GN sources
module GnCrossmap
  INPUT_MODE = "r:utf-8"
  OUTPUT_MODE = "w:utf-8"
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

    # rubocop:disable Metrics/AbcSize

    def run(opts)
      opts = opts_struct(opts)
      input_io, output_io = io(opts.input, opts.output)
      reader = create_reader(input_io, opts)
      data = block_given? ? reader.read(&Proc.new) : reader.read
      writer = create_writer(reader, output_io, opts)
      resolver = Resolver.new(writer, opts)
      block_given? ? resolver.resolve(data, &Proc.new) : resolver.resolve(data)
      resolver.stats
    end

    # rubocop:enable all

    def logger
      @logger ||= Logger.new(STDERR)
    end

    def log(message)
      logger.info(message)
    end

    def find_id(row, name)
      if row.key?(:taxonid) && row[:taxonid]
        row[:taxonid].to_s.strip
      else
        GnUUID.uuid(name.to_s)
      end
    end

    def opts_struct(opts)
      resolver_url = "http://resolver.globalnames.org/name_resolvers.json"
      threads = opts[:threads].to_i
      opts[:threads] = threads.between?(1, 10) ? threads : 2
      with_classification = opts[:with_classification] ? true : false
      opts[:with_classification] = with_classification
      data_source_id = opts[:data_source_id].to_i
      opts[:data_source_id] = data_source_id.zero? ? 1 : data_source_id
      OpenStruct.new({ stats: Stats.new, alt_headers: [],
                       resolver_url: resolver_url }.merge(opts))
    end

    private

    def create_writer(reader, output_io, opts)
      Writer.new(output_io, reader.original_fields,
                 output_name(opts.output), opts.with_classification)
    end

    def create_reader(input_io, opts)
      Reader.new(input_io, input_name(opts.input),
                 opts.skip_original, opts.alt_headers, opts.stats)
    end

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
