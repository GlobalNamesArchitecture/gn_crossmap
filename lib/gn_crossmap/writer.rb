# frozen_string_literal: true

module GnCrossmap
  # Saves output from GN Resolver to disk
  class Writer
    def initialize(output_io, original_fields, output_name,
                   with_classification = false)
      @output_io = output_io
      @output_fields = output_fields(original_fields)
      @output_fields << :classification if with_classification
      @output = CSV.new(@output_io, col_sep: "\t")
      @output << @output_fields
      @output_name = output_name
      GnCrossmap.log("Open output to #{@output_name}")
    end

    def write(record)
      @output << record
    end

    def close
      GnCrossmap.log("Close #{@output_name}")
      @output_io.close
    end

    private

    def output_fields(original_fields)
      original_fields + %i[matchedType inputName matchedName inputCanonicalForm
                           matchedCanonicalForm inputRank matchedRank
                           synonymStatus acceptedName matchedEditDistance
                           matchedScore matchTaxonID]
    end
  end
end
