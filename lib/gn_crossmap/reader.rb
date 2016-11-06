module GnCrossmap
  # Reads supplied csv file and creates ruby structure to compare
  # with a Global Names Resolver source
  class Reader
    attr_reader :original_fields

    def initialize(csv_io)
      @csv_io = csv_io
      @col_sep = col_sep
      @original_fields = nil
    end

    def read
      GnCrossmap.log("Read input file '#{@csv_io.inspect}'")
      parse_input
    end

    private

    def col_sep
      line = @csv_io.readline
      @csv_io.rewind
      [";", ",", "\t"].map { |s| [line.count(s), s] }.sort.last.last
    end

    def parse_input
      dc = Collector.new
      csv = CSV.new(@csv_io, col_sep: @col_sep)
      csv.each_with_index do |row, i|
        @original_fields = row.dup if @original_fields.nil?
        i += 1
        GnCrossmap.log("Ingesting #{i}th csv row") if (i % 10_000).zero?
        dc.process_row(row)
      end && @csv_io.close
      dc.data
    end
  end
end
