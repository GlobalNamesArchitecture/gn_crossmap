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
end
