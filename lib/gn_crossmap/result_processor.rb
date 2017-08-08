# frozen_string_literal: true

module GnCrossmap
  # Processes data received from the GN Resolver
  class ResultProcessor
    attr_reader :input, :writer

    def initialize(writer, stats, with_classification = false)
      @with_classification = with_classification
      @parser = ScientificNameParser.new
      @stats = stats
      @writer = writer
      @input = {}
    end

    def process(result, original_data)
      @original_data = original_data
      res = rubyfy(result)
      res[:data].each do |d|
        d[:results].nil? ? write_empty_result(d) : write_result(d)
      end
    end

    private

    def rubyfy(result)
      JSON.parse(result, symbolize_names: true)
    end

    def write_empty_result(datum)
      @stats.stats[:matches][0] += 1
      @stats.stats[:resolved_records] += 1
      res = @original_data[datum[:supplied_id]]
      res += [GnCrossmap::MATCH_TYPES[0], datum[:supplied_name_string], nil,
              datum[:supplied_canonical_form], nil,
              @input[datum[:supplied_id]][:rank], nil, nil, nil, nil]
      @writer.write(res)
    end

    def write_result(datum)
      collect_stats(datum)
      datum[:results].each do |result|
        @writer.write(compile_result(datum, result))
      end
    end

    def collect_stats(datum)
      match_num = datum[:results].map { |d| d[:match_type] }.min
      @stats.stats[:matches][match_num] += 1
      @stats.stats[:resolved_records] += 1
    end

    def compile_result(datum, result)
      @original_data[datum[:supplied_id]] + new_data(datum, result)
    end

    # rubocop:disable Metrics/AbcSize

    def new_data(datum, result)
      synonym = result[:current_name_string] ? "synonym" : nil
      res = [matched_type(result), datum[:supplied_name_string],
             result[:name_string], canonical(datum[:supplied_name_string]),
             result[:canonical_form], result[:edit_distance],
             @input[datum[:supplied_id]][:rank], matched_rank(result), synonym,
             result[:current_name_string] || result[:name_string],
             result[:score], result[:taxon_id]]
      res << classification(result) if @with_classification
      res
    end

    # rubocop:enable all

    def canonical(name_string)
      parsed = @parser.parse(name_string)[:scientificName]
      parsed[:canonical].nil? || parsed[:hybrid] ? nil : parsed[:canonical]
    rescue StandardError
      @parser = ScientificNameParser.new
      nil
    end

    def matched_rank(record)
      record[:classification_path_ranks].split("|").last
    end

    def matched_type(record)
      GnCrossmap::MATCH_TYPES[record[:match_type]]
    end

    # rubocop:disable Metrics/AbcSize

    def classification(result)
      return nil if result[:classification_path].to_s.strip == ""
      path = result[:classification_path].split("|")
      ranks = result[:classification_path_ranks].split("|")
      if path.size == ranks.size
        path = path.zip(ranks).map { |e| "#{e[0]}(#{e[1]})" }
      end
      path.join(", ")
    end

    # rubocop:enable all
  end
end
