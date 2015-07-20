module GnCrossmap
  # Saves output from GN Resolver to disk
  class Writer
    def initialize(output_path, original_fields)
      @path = output_path
      @output_fields = output_fields(original_fields)
      @output = CSV.open(@path, "w:utf-8")
      @output << @output_fields
      GnCrossmap.log("Open output file '#{@path}'")
    end

    def write(record)
      @output << record
    end

    def close
      GnCrossmap.log("Close output file '#{@path}'")
      @output.close
    end

    private

    def output_fields(original_fields)
      original_fields + [:matchedType, :inputName, :matchedName,
                         :matchedCanonicalForm, :inputRank, :matchedRank,
                         :synonymStatus, :acceptedName, :matchedEditDistance,
                         :marchedScore, :matchTaxonID]
    end
  end
end
