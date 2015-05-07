module GnCrossmap
  # Saves output from GN Resolver to disk
  class Writer
    def initialize(output_path)
      @output = CSV.open(output_path, "w:utf-8")
      @output << [:taxonID, :scientificName, :matchedScientificName,
                  :matchedCanonicalForm, :rank, :matchedRank, :matchType,
                  :editDistance, :score]
    end

    def write(record)
      @output << record
    end

    def close
      @output.close
    end
  end
end
