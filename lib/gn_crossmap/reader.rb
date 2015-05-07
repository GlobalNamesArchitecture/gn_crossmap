module GnCrossmap
  # Reads supplied csv file and creates ruby structure to compare
  # with a Global Names Resolver source
  class Reader
    def initialize(csv_path)
      @csv_file = csv_path
      @input = nil
    end

    def read
      parse_input
    end

    private

    def parse_input
      dc = DataCollector.new
      CSV.open(@csv_file, col_sep: ";").each do |row|
        dc.process_row(row)
      end
      @input = dc.data
    end
  end
end
