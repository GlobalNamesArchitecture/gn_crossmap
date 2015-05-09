module GnCrossmap
  # Reads supplied csv file and creates ruby structure to compare
  # with a Global Names Resolver source
  class Reader
    def initialize(csv_path)
      @csv_file = csv_path
    end

    def read
      GnCrossmap.log("Read input file '#{File.basename(@csv_file)}'")
      parse_input
    end

    private

    def parse_input
      dc = DataCollector.new
      col_sep = GnCrossmap.which_col_sep(@csv_file)
      CSV.open(@csv_file, col_sep: col_sep).each do |row|
        dc.process_row(row)
      end
      dc.data
    end
  end
end
