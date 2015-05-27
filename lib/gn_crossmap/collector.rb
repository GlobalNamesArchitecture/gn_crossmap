module GnCrossmap
  # Assemble data from CSV reader by checking column fields
  class Collector
    attr_reader :data

    def initialize
      @data = []
      @fields = nil
      @collector = nil
    end

    def process_row(row)
      @row = row
      @fields ? collect_data : init_fields_collector
    end

    private

    def init_fields_collector
      @fields = @row.map { |f| f.strip.downcase.to_sym }
      @collector = collector_factory
    end

    def collect_data
      @row = @fields.zip(@row).to_h
      data = @collector.id_name_rank(@row)
      @data << data if data
    end

    def collector_factory
      if @fields.include?(:scientificname)
        SciNameCollector.new(@fields)
      else
        ColumnCollector.new(@fields)
      end
    end
  end
end
