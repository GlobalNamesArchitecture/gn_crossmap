# frozen_string_literal: true

module GnCrossmap
  # Reads supplied csv file and creates ruby structure to compare
  # with a Global Names Resolver source
  class Reader
    attr_reader :original_fields, :col_sep

    def initialize(csv_io, input_name, skip_original, alt_headers, stats)
      @stats = stats
      @alt_headers = alt_headers
      @csv_io = csv_io
      @col_sep = detect_col_sep
      @quote_char = quote_char(@col_sep)
      @original_fields = nil
      @input_name = input_name
      @skip_original = skip_original
    end

    def read
      @stats.stats[:ingestion_start] = Time.now
      @stats.stats[:status] = :ingestion
      GnCrossmap.log("Read input from #{@input_name}")
      block_given? ? parse_input(&Proc.new) : parse_input
    end

    private

    def detect_col_sep
      line = @csv_io.first
      @stats.stats[:total_records] = @csv_io.readlines.size
      @csv_io.rewind
      data = [[";", 1], [",", 0], ["\t", 2]].map do |s, weight|
        [line.count(s), weight, s]
      end
      data.sort.last.last
    end

    def quote_char(col_sep)
      col_sep == "\t" ? "\x00" : '"'
    end

    def parse_input
      dc = Collector.new(@skip_original)
      csv = CSV.new(@csv_io, col_sep: @col_sep, quote_char: @quote_char)
      block_given? ? process(csv, dc, &Proc.new) : process(csv, dc)
      wrap_up
      yield @stats.stats if block_given?
      dc.data
    end

    def process(csv, data_collector)
      counter = 0
      loop do
        yield @stats.stats if log_progress(counter) && block_given?
        rl = read_line(csv, data_collector)
        break unless rl
        counter += 1
      end && @csv_io.close
    end

    def read_line(csv, data_collector)
      row = csv.readline
      return false if row.nil?
      row = process_headers(row) if @original_fields.nil?
      data_collector.process_row(row)
    rescue CSV::MalformedCSVError => e
      @stats.stats[:errors] << e.message if @stats.stats[:errors].size < 10
    end

    def wrap_up
      @stats.stats[:ingested_records] = @stats.stats[:total_records]
      @stats.stats[:ingestion_span] = Time.now - @stats.stats[:ingestion_start]
    end

    def process_headers(row)
      @original_fields = headers(row)
      row = produce_alt_headers(row) unless @alt_headers&.empty?
      row
    end

    def produce_alt_headers(row)
      tail_size = row.size - @alt_headers.size
      if tail_size <= 0
        @alt_headers = @alt_headers[0..row.size - 1]
      else
        tail_size.times { @alt_headers << "" }
      end
      @alt_headers = @alt_headers.map { |h| h.nil? ? "" : h }
    end

    def log_progress(count)
      return false unless (count % 1_000).zero?
      GnCrossmap.log("Ingesting csv row #{count + 1}")
      @stats.stats[:ingested_records] = count + 1
      @stats.stats[:ingestion_span] = Time.now - @stats.stats[:ingestion_start]
      true
    end

    def headers(row)
      hdrs = row.dup
      @skip_original ? taxon_id_header(hdrs) : hdrs
    end

    def taxon_id_header(hdrs)
      hdrs.each do |h|
        return [h] if h&.match?(/taxonid\s*$/i)
      end
      []
    end
  end
end
