describe GnCrossmap::Stats do
  subject { GnCrossmap::Stats }
  describe ".new" do
    it "creates an instance" do
      expect(subject.new).to be_kind_of GnCrossmap::Stats
    end
  end
end
