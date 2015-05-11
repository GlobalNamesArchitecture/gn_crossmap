module GnCrossmap
  # Assemble data from CSV reader by parsing scientificName field
  class ParserCollector
    def initialize(fields)
      @data = []
      @fields = fields
    end

    def process_row(row)
      @row = row
      collect_data
    end

    private

    def collect_data
      @row = @fields.zip(@row).to_h
    end
  end
end
