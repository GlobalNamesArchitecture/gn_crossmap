describe GnCrossmap do
  subject { GnCrossmap }

  describe ".version" do
    it "has a version number" do
      expect(subject::VERSION).to match(/^\d+\.\d+\.\d+$/)
      expect(subject.version).to match(/^\d+\.\d+\.\d+$/)
    end
  end

  describe ".run" do
    let(:input) { FILES[:all_fields] }
    let(:output) { FILES[:output] }
    let(:data_source_id) { 1 }
    it "runs crossmapping" do
      expect(subject.run(input, output, data_source_id)).to eq output
    end
  end

  describe ".which_col_sep" do
    let(:input) { FILES[:all_fields] }
    it "returns separator of csv file" do
      expect(subject.which_col_sep(input)).to eq ";"
    end
  end
end
