module GnCrossmap
  # Reads supplied csv file and creates ruby structure to compare
  # with a Global Names Resolver source
  class Reader
    attr_reader :original_fields

    def initialize(csv_io, input_name, skip_original)
      @csv_io = csv_io
      @col_sep = col_sep
      @original_fields = nil
      @input_name = input_name
      @skip_original = skip_original
    end

    def read
      GnCrossmap.log("Read input from #{@input_name}")
      parse_input
    end

    private

    def col_sep
      line = @csv_io.first
      @csv_io.rewind
      [";", ",", "\t"].map { |s| [line.count(s), s] }.sort.last.last
    end

    def parse_input
      dc = Collector.new(@skip_original)
      csv = CSV.new(@csv_io, col_sep: col_sep)
      csv.each_with_index do |row, i|
        @original_fields = headers(row) if @original_fields.nil?
        i += 1
        GnCrossmap.log("Ingesting #{i}th csv row") if (i % 10_000).zero?
        dc.process_row(row)
      end && @csv_io.close
      dc.data
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
