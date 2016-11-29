module GnCrossmap
  # Processes data received from the GN Resolver
  class ResultProcessor
    attr_reader :input, :writer

    def initialize(writer, stats)
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
              nil, @input[datum[:supplied_id]][:rank], nil,
              nil, nil, nil]
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

    def new_data(datum, result)
      synonym = result[:current_name_string] ? "synonym" : nil
      [matched_type(result), datum[:supplied_name_string],
       result[:name_string], result[:canonical_form],
       @input[datum[:supplied_id]][:rank], matched_rank(result),
       synonym, result[:current_name_string] || result[:name_string],
       result[:edit_distance], result[:score], result[:taxon_id]]
    end

    def matched_rank(record)
      record[:classification_path_ranks].split("|").last
    end

    def matched_type(record)
      GnCrossmap::MATCH_TYPES[record[:match_type]]
    end
  end
end
