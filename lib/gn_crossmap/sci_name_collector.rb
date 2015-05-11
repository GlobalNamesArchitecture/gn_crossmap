module GnCrossmap
  # Assemble data from CSV reader by parsing scientificName field
  class SciNameCollector
    def initialize(fields)
      @fields = fields
      @parser = ScientificNameParser.new
    end

    def id_name_rank(row)
      @row = row
      id = @row[:taxonid]
      name = find_name
      rank = @row[:taxonRank]
      rank = parse_rank if rank.nil?
      (id && name) ? { id: id, name: name, rank: rank } : nil
    end

    private

    def find_name
      name = @row[:scientificname].strip
      authorship = @row[:scientificnameauthorship].to_s.strip
      name = "#{name} #{authorship}" if authorship != ""
      name
    end

    def parse_rank
      @parsed_name = @parser.parse(@row[:scientificname])[:scientificName]
      return nil if !@parsed_name[:canonical] || @parsed_name[:hybrid]
      words_num = @parsed_name[:canonical].split(" ").size
      infer_rank(words_num)
    rescue RuntimeError
      @parser = ScientificNameParser.new
      nil
    end

    def infer_rank(words_in_canonical_form)
      case words_in_canonical_form
      when 1
        nil
      when 2
        "species"
      else
        normalize_rank(@parsed_name[:details][0][:infraspecies][-1][:rank])
      end
    end

    def normalize_rank(rank)
      case rank
      when /^f/
        "form"
      when /^var/
        "variety"
      when /^sub/
        "subspicies"
      else
        rank
      end
    end
  end
end
