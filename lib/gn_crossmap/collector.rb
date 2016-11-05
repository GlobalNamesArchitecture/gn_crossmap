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
      @fields = @row.map { |f| prepare_field(f) }
      @collector = collector_factory
      err = "taxonID must be present in the csv header"
      raise GnCrossmapError, err unless @fields.include?(:taxonid)
    end

    def prepare_field(field)
      field = field.to_s.tr(":", "/")
      field.split("/")[-1].strip.downcase.to_sym
    end

    def collect_data
      @row = @fields.zip(@row).to_h
      data = @collector.id_name_rank(@row)
      return unless data
      data[:original] = @row.values
      @data << data
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
