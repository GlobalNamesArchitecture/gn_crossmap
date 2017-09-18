# frozen_string_literal: true

module GnCrossmap
  # Collects statistics about crossmapping process
  class Stats
    attr_accessor :stats

    def initialize
      @stats = { status: :init, total_records: 0, ingested_records: 0,
                 ingestion_span: nil, ingestion_start: nil,
                 resolution: eta_struct,
                 matches: match_types, errors: [] }
      @smooth = 0.05
    end

    def penalty(threads)
      pnlt = 0.7
      penalty_adj(threads.to_i, 1, pnlt)
    end

    def update_eta(current_speed)
      eta = @stats[:resolution]
      eta[:speed] = current_speed if eta[:speed].nil?
      eta[:speed] = eta[:speed] * (1 - @smooth) + current_speed * @smooth
      eta[:eta] = (@stats[:total_records] -
                   @stats[:resolution][:completed_records]) /
                  eta[:speed]
    end

    private

    def eta_struct
      { start_time: nil, completed_records: 0, time_span: 0,
        speed: nil, eta: nil, stop_time: nil }
    end

    def match_types
      matches = GnCrossmap::MATCH_TYPES.keys
      matches.each_with_object({}) do |key, obj|
        obj[key] = 0
      end
    end

    def penalty_adj(threads, val, pnlt)
      return val if threads < 2
      val + penalty_adj(threads - 1, (val * pnlt), pnlt)
    end
  end
end
