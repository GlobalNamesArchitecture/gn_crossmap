module GnCrossmap
  # Processes data received from the GN Resolver
  class ResultProcessor
    MATCH_TYPES = {
      1 => "Exact match",
      2 => "Canonical form exact match",
      3 => "Canonical form fuzzy match",
      4 => "Partial canonical form match",
      5 => "Partial canonical form fuzzy match",
      6 => "Genus part match"
    }

    attr_reader :input, :writer

    def initialize(writer)
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
      res = @original_data[datum[:supplied_id]]
      res += [datum[:supplied_name_string], nil, nil,
              @input[datum[:supplied_id]][:rank], nil, nil, nil, nil]
      @writer.write(res)
    end

    def write_result(datum)
      datum[:results].each do |result|
        @writer.write(compile_result(datum, result))
      end
    end

    def compile_result(datum, result)
      @original_data[datum[:supplied_id]] +
        [datum[:supplied_name_string], result[:name_string],
         result[:canonical_form], @input[datum[:supplied_id]][:rank],
         matched_rank(result), matched_type(result),
         result[:edit_distance], result[:score]]
    end

    def matched_rank(record)
      record[:classification_path_ranks].split("|").last
    end

    def matched_type(record)
      MATCH_TYPES[record[:match_type]]
    end
  end
end
