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

    attr_reader :input

    def initialize(writer)
      @writer = writer
      @input = {}
    end

    def process(result)
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
      res = [datum[:supplied_id], datum[:supplied_name_string], nil, nil,
             @input[datum[:supplied_id]][:rank], nil, nil, nil, nil]
      @writer.write(res)
    end

    def write_result(datum)
      datum[:results].each do |r|
        res = [datum[:supplied_id], datum[:supplied_name_string],
               r[:name_string], r[:canonical_form],
               @input[datum[:supplied_id]][:rank],
               matched_rank(r), matched_type(r),
               r[:edit_distance], r[:score]]
        @writer.write(res)
      end
    end

    def matched_rank(record)
      record[:classification_path_ranks].split("|").last
    end

    def matched_type(record)
      MATCH_TYPES[record[:match_type]]
    end
  end
end
