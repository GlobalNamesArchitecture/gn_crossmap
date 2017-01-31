module GnCrossmap
  # Reads supplied csv file and creates ruby structure to compare
  # with a Global Names Resolver source
  class Reader
    attr_reader :original_fields

    def initialize(csv_io, input_name, skip_original, alt_headers, stats)
      @stats = stats
      @alt_headers = alt_headers
      @csv_io = csv_io
      @col_sep = col_sep
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

    def col_sep
      line = @csv_io.first
      @stats.stats[:total_records] = @csv_io.readlines.size
      @csv_io.rewind
      [";", ",", "\t"].map { |s| [line.count(s), s] }.sort.last.last
    end

    def parse_input
      dc = Collector.new(@skip_original)
      csv = CSV.new(@csv_io, col_sep: col_sep)
      block_given? ? process(csv, dc, &Proc.new) : process(csv, dc)
      wrap_up
      yield @stats.stats if block_given?
      dc.data
    end

    def process(csv, data_collector)
      csv.each_with_index do |row, i|
        row = process_headers(row) if @original_fields.nil?
        yield @stats.stats if log_progress(i) && block_given?
        data_collector.process_row(row)
      end && @csv_io.close
    end

    def wrap_up
      @stats.stats[:ingested_records] = @stats.stats[:total_records]
      @stats.stats[:ingestion_span] = Time.now - @stats.stats[:ingestion_start]
    end

    def process_headers(row)
      @original_fields = headers(row)
      row = @alt_headers unless @alt_headers.empty?
      row
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
        return [h] if h =~ /taxonid\s*$/i
      end
      []
    end
  end
end
