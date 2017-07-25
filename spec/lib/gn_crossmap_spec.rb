describe GnCrossmap do
  subject { GnCrossmap }

  describe ".version" do
    it "has a version number" do
      expect(subject::VERSION).to match(/^\d+\.\d+\.\d+$/)
      expect(subject.version).to match(/^\d+\.\d+\.\d+$/)
    end
  end

  describe ".run" do
    let(:opts) do
      { input: FILES[:sciname_auth],
        output: FILES[:output],
        data_source_id: 1,
        skip_original: false }
    end
    it "runs crossmapping" do
      expect(subject.run(opts)).
        to be_kind_of GnCrossmap::Stats
    end

    context "spaces in fields" do
      let(:opts2) { opts.merge(input: FILES[:spaces_in_fields]) }
      it "suppose to work even when fields have additional spaces" do
        expect(subject.run(opts2)).
          to be_kind_of GnCrossmap::Stats
        expect(File.readlines(opts[:output]).size).to be > 100
      end
    end

    context "original fields flag" do
      let(:opts3) { opts.merge(skip_original: true) }
      let(:opts4) { opts.merge(input: FILES[:no_taxonid], skip_original: true) }
      it "leaves only taxonID when skip_original is true" do
        i = File.open(opts3[:input])
        expect(i.first).to include("taxonRank")
        i.close
        subject.run(opts3)
        o = File.open(opts3[:output])
        expect(o.first).to_not include("taxonRank")
        o.close
      end

      it "leaves no original fields if there is no taxonID" do
        i = File.open(opts4[:input])
        headers = i.first
        expect(headers).to include("scientificName")
        expect(headers).to include("taxonRank")
        i.close
        subject.run(opts4)
        o = File.open(opts4[:output])
        headers = o.first
        expect(headers).to_not include("taxonID")
        expect(headers).to_not include("scientificName")
        expect(headers).to_not include("taxonRank")
        o.close
      end

      it "keeps original fields when skip_original is false" do
        i = File.open(opts[:input])
        expect(i.first).to include("taxonRank")
        i.close
        subject.run(opts)
        o = File.open(opts[:output])
        expect(o.first).to include("taxonRank")
        o.close
      end
    end

    context "no taxonid" do
      let(:opts4) { opts.merge(input: FILES[:no_taxonid]) }
      it "works without taxonid" do
        subject.run(opts4)
        expect(File.readlines(opts[:output]).size).to be > 100
      end
    end

    context "yielding details" do
      let(:opts5) { opts.merge(input: FILES[:sciname_auth]) }
      it "gets access to intermediate details" do
        states = []
        subject.run(opts5) do |stats|
          states << stats[:status]
          expect(stats[:total_records]).to be 301
          expect([0, 200, 301].include?(stats[:resolved_records])).to be true
          matches = stats[:matches].values.inject(:+)
          expect(matches).to be stats[:resolved_records]
          expect(stats.keys).
            to match_array %i[status total_records ingested_records
                              resolved_records ingestion_span
                              resolution_span ingestion_start
                              resolution_start last_batches_time
                              matches resolution_stop errors]
        end
        expect(states.uniq).to match_array %i[ingestion resolution finish]
      end
    end
  end
end
