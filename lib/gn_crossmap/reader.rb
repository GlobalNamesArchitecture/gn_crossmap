module GnCrossmap
  # Reads supplied csv file and creates ruby structure to compare
  # with a Global Names Resolver source
  class Reader
    attr_reader :original_fields

    def initialize(csv_path)
      @csv_file = csv_path
      @col_sep = col_sep
      @original_fields = nil
    end

    def read
      GnCrossmap.log("Read input file '#{File.basename(@csv_file)}'")
      parse_input
    end

    private

    def col_sep
      line = open(@csv_file, &:readline)
      [";", ",", "\t"].map { |s| [line.count(s), s] }.sort.last.last
    end

    def parse_input
      dc = Collector.new
      CSV.open(@csv_file, col_sep: @col_sep).each_with_index do |row, i|
        @original_fields = row.dup if @original_fields.nil?
        i += 1
        GnCrossmap.log("Ingesting #{i}th csv row") if (i % 10_000).zero?
        dc.process_row(row)
      end
      dc.data
    end
  end
end
