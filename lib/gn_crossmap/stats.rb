# frozen_string_literal: true

module GnCrossmap
  # Collects statistics about crossmapping process
  class Stats
    attr_accessor :stats

    def initialize
      @stats = { status: :init, total_records: 0, ingested_records: 0,
                 resolved_records: 0, ingestion_span: nil,
                 resolution_span: nil, ingestion_start: nil,
                 resolution_start: nil, last_batches_time: [],
                 matches: match_types }
    end

    private

    def match_types
      matches = GnCrossmap::MATCH_TYPES.keys
      matches.each_with_object({}) do |key, obj|
        obj[key] = 0
      end
    end
  end
end
