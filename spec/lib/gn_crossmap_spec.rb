describe GnCrossmap do
  subject { GnCrossmap }

  describe ".version" do
    it "has a version number" do
      expect(subject::VERSION).to match(/^\d+\.\d+\.\d+$/)
      expect(subject.version).to match(/^\d+\.\d+\.\d+$/)
    end
  end

  describe ".run" do
    let(:input) { FILES[:sciname_auth] }
    let(:output) { FILES[:output] }
    let(:data_source_id) { 1 }
    it "runs crossmapping" do
      expect(subject.run(input, output, data_source_id)).to eq output
    end

    context "spaces in fields" do
      let(:input) { FILES[:spaces_in_fields] }
      it "suppose to work even when fields have additional spaces" do
        expect(subject.run(input, output, data_source_id)).to eq output
        expect(File.readlines(output).size).to be > 100
      end
    end

    context "no taxonid" do
      let(:input) { FILES[:no_taxonid] }
      it "raises an error" do
        expect { subject.run(input, output, data_source_id) }.
          to raise_error GnCrossmapError
      end
    end
  end
end
