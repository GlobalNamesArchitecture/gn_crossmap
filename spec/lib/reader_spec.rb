describe GnCrossmap::Reader do
  let(:csv_io) { io(FILES[:all_fields], "r:utf-8") }
  let(:skip_original) { false }
  subject { GnCrossmap::Reader.new(csv_io, FILES[:all_fields], skip_original) }

  describe ".new" do
    it "creates instance" do
      expect(subject).to be_kind_of GnCrossmap::Reader
    end
  end

  describe "#read" do
    it "returns data from csv file" do
      input = subject.read
      expect(input).to be_kind_of Array
      expect(input.first).to eq(
        id: "1", name: "Animalia", rank: "kingdom",
        original: ["1", "Animalia", nil, nil, nil, nil, nil, nil, nil, nil,
                   nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
                   nil, nil, nil, nil, nil]
      )
    end
  end
end
