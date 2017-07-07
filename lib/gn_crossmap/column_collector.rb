module GnCrossmap
  # Assemble data from CSV reader by checking column fields
  class ColumnCollector
    RANKS = %i[kingdom subkingdom phylum subphylum superclass class
               subclass cohort superorder order suborder infraorder superfamily
               family subfamily tribe subtribe genus subgenus section species
               subspecies variety form].freeze
    SPECIES_RANKS = %i[genus species subspecies variety form].freeze

    def initialize(fields)
      @fields = fields
      err = "At least some of these fields must exist in " \
        "the CSV header: '#{RANKS.join('\', \'')}'"
      raise GnCrossmapError, err if (RANKS - @fields).size == RANKS.size
    end

    def id_name_rank(row)
      @row = row
      rank = find_rank
      return nil unless rank
      name = assemble_name(rank)
      return nil unless name
      id = GnCrossmap.find_id(@row, name)
      return nil if id.strip.to_s == ""
      { id: id, name: name, rank: rank.to_s }
    end

    private

    def find_rank
      name_rank = nil
      RANKS.reverse_each do |rank|
        next if @row[rank].to_s.strip == ""
        name_rank = rank
        break
      end
      name_rank
    end

    def assemble_name(name_rank)
      name = @row[name_rank]
      if SPECIES_RANKS[1..-1].include?(name_rank)
        name = assemble_species_name(name, name_rank)
      end
      name
    end

    def assemble_species_name(name, name_rank)
      ending = [add_infrarank(name, name_rank), @row[:scientificnameauthorship]]
      ranks = SPECIES_RANKS[0...SPECIES_RANKS.index(name_rank)]
      starting = name_start(ranks)
      (starting + ending).flatten.join(" ").strip.gsub(/\s+/, " ")
    end

    def name_start(ranks)
      ranks.each_with_object([]) do |rank, ary|
        next unless @row[rank]
        ary << add_infrarank(@row[rank], rank)
      end
    end

    def add_infrarank(name, rank)
      case rank
      when :subspecies
        "subsp. #{name}"
      when :variety
        "var. #{name}"
      when :form
        "f. #{name}"
      else
        name
      end
    end
  end
end
