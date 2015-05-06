module GnCrossmap
  # Organizes data from CSV reader
  class DataCollector
    attr_reader :data

    def initialize
      @data = []
      @count = 0
      @fields = []
    end

    def process_row(row)
      @row = row
      @count += 1
      @count == 1 ? collect_fields : collect_data
    end

    private

    def collect_fields
      @fields = @row.map(&:downcase)
    end

    def collect_data
      record = fields.zip(row).to_h
      record
    end
  end
end
