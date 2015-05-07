describe GnCrossmap::Reader do
  let(:csv_path) { FILES[:all_fields] }
  subject { GnCrossmap::Reader.new(csv_path) }

  describe ".new" do
    it "creates instance" do
      expect(subject).to be_kind_of GnCrossmap::Reader
    end
  end

  describe "#read" do
    it "returns data from csv file" do
      input = subject.read
      expect(input).to be_kind_of Array
      expect(input.first).
        to eq(id: "1", name: "Animalia", rank: "kingdom")
    end
  end
end
