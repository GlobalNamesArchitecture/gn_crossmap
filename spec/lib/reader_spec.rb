describe GnCrossmap::Reader do
  let(:csv_path) do
    File.expand_path("../files/wellformed-semicolon.csv", __dir__)
  end
  subject { GnCrossmap::Reader.new(csv_path) }

  describe ".new" do
    it "creates instance" do
      expect(subject).to be_kind_of GnCrossmap::Reader
    end
  end
end
