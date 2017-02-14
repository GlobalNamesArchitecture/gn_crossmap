describe "features" do
  context "resolving variety of csv files" do
    %i(all_fields sciname sciname_auth sciname_rank csv_relaxed).each do |input|
      context input do
        it "resolves #{input}" do
          opts = { output: "/tmp/#{input}-processed.csv",
                   input: FILES[input],
                   data_source_id: 1,
                   skip_original: true }
          FileUtils.rm(opts[:output]) if File.exist?(opts[:output])
          GnCrossmap.run(opts)
          expect(File.exist?(opts[:output])).to be true
        end
      end
    end
  end

  context "combining acceptedName output" do
    it "gives accepted name for all matches" do
      opts = { output: "/tmp/output.csv",
               input: FILES[:sciname],
               data_source_id: 1, skip_original: true }
      GnCrossmap.run(opts)
      CSV.open(opts[:output], col_sep: "\t", headers: true).each do |r|
        next unless r["matchedEditDistance"] == "0"
        expect(r["matchedName"].size).to be > 1
        expect(r["acceptedName"].size).to be > 1
        if r["synonymStatus"]
          expect(r["matchedName"]).to_not eq r["acceptedName"]
        else
          expect(r["matchedName"]).to eq r["acceptedName"]
        end
      end
      FileUtils.rm(opts[:output])
    end
  end

  context "use alternative headers" do
    it "uses alternative headers for resolution" do
      opts = { output: "/tmp/output.csv",
               input: FILES[:no_taxonid],
               data_source_id: 1, skip_original: true,
               alt_headers: %w(taxonID scientificName rank) }
      GnCrossmap.run(opts)
      CSV.open(opts[:output], col_sep: "\t", headers: true).each do |r|
        next unless r["matchedEditDistance"] == "0"
        expect(r["matchedName"].size).to be > 1
        expect(r["acceptedName"].size).to be > 1
      end
      FileUtils.rm(opts[:output])
    end

    it "breaks without alternative headers" do
      opts = { output: "/tmp/output.csv",
               input: FILES[:no_taxonid],
               data_source_id: 1, skip_original: 1 }
      expect do
        GnCrossmap.run(opts)
      end.to raise_error GnCrossmapError
      FileUtils.rm(opts[:output])
    end

    it "uses complex alternative headers" do
      opts = { output: "/tmp/output.csv",
               input: FILES[:fix_headers],
               data_source_id: 1, skip_original: true,
               alt_headers: %w(nil nil taxonID rank genus species nil scientificNameAuthorship, nil) }
      GnCrossmap.run(opts)
      CSV.open(opts[:output], col_sep: "\t", headers: true).each do |r|
        next unless r["matchedEditDistance"] == "0"
        expect(r["matchedName"].size).to be > 1
        expect(r["acceptedName"].size).to be > 1
      end
      FileUtils.rm(opts[:output])

    end
  end

  context "stop trigger" do
    it "stops process with a 'STOP' command" do
      opts = { output: "/tmp/output.csv",
               input: FILES[:sciname],
               data_source_id: 1, skip_original: true }
      GnCrossmap.run(opts) { "STOP" }
      lines_num = File.readlines(opts[:output]).size
      expect(lines_num).to be 201
      FileUtils.rm(opts[:output])
    end
  end
end
