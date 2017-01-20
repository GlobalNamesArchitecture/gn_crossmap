describe "features" do
  context "resolving variety of csv files" do
    %i(all_fields sciname sciname_auth sciname_rank).each do |input|
      context input do
        it "resolves #{input}" do
          output = "/tmp/#{input}-processed.csv"
          input = FILES[input]
          FileUtils.rm(output) if File.exist?(output)
          GnCrossmap.run(input, output, 1, true)
          expect(File.exist?(output)).to be true
        end
      end
    end
  end

  context "combining acceptedName output" do
    it "gives accepted name for all matches" do
      output = "/tmp/output.csv"
      input = FILES[:sciname]
      GnCrossmap.run(input, output, 1, true)
      CSV.open(output, col_sep: "\t", headers: true).each do |r|
        next unless r["matchedEditDistance"] == "0"
        expect(r["matchedName"].size).to be > 1
        expect(r["acceptedName"].size).to be > 1
        if r["synonymStatus"]
          expect(r["matchedName"]).to_not eq r["acceptedName"]
        else
          expect(r["matchedName"]).to eq r["acceptedName"]
        end
      end
      FileUtils.rm(output)
    end
  end

  context "use alternative headers" do
    it "uses alternative headers for resolution" do
      output = "/tmp/output.csv"
      input = FILES[:no_taxonid]
      alt_headers = %w(taxonID scientificName rank)
      GnCrossmap.run(input, output, 1, true, alt_headers)
      CSV.open(output, col_sep: "\t", headers: true).each do |r|
        next unless r["matchedEditDistance"] == "0"
        expect(r["matchedName"].size).to be > 1
        expect(r["acceptedName"].size).to be > 1
      end
      FileUtils.rm(output)
    end

    it "breaks without alternative headers" do
      output = "/tmp/output.csv"
      input = FILES[:no_taxonid]
      expect do
        GnCrossmap.run(input, output, 1, true)
      end.to raise_error GnCrossmapError
      FileUtils.rm(output)
    end
  end
end
