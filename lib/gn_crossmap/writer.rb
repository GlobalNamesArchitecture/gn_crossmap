module GnCrossmap
  # Saves output from GN Resolver to disk
  class Writer
    def initialize(output_path)
      @path = output_path
      @output = CSV.open(@path, "w:utf-8")
      @output << [:taxonID, :scientificName, :matchedScientificName,
                  :matchedCanonicalForm, :rank, :matchedRank, :matchType,
                  :editDistance, :score]
      GnCrossmap.log("Open output file '#{@path}'")
    end

    def write(record)
      @output << record
    end

    def close
      GnCrossmap.log("Close output file '#{@path}'")
      @output.close
    end
  end
end
