# frozen_string_literal: true

module GnCrossmap
  # Assemble data from CSV reader by checking column fields
  class Collector
    attr_reader :data

    def initialize(skip_original)
      @data = []
      @fields = nil
      @collector = nil
      @skip_original = skip_original
    end

    def process_row(row)
      @row = row
      @fields ? collect_data : init_fields_collector
      true
    end

    private

    def init_fields_collector
      @fields = @row.map { |f| prepare_field(f) }
      @collector = collector_factory
    end

    def prepare_field(field)
      field = field.to_s.tr(":", "/")
      return :none if field == ""
      field.split("/")[-1].strip.downcase.to_sym
    end

    def collect_data
      @row = @fields.zip(@row)
      @row_hash = @row.to_h
      data = @collector.id_name_rank(@row_hash)
      return unless data
      data[:original] = prepare_original
      @data << data
    end

    def prepare_original
      @skip_original ? [@row_hash[:taxonid]] : @row.map(&:last)
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
