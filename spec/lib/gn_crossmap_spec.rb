describe GnCrossmap do
  subject { GnCrossmap }

  describe ".version" do
    it "has a version number" do
      expect(subject::VERSION).to match(/^\d+\.\d+\.\d+$/)
      expect(subject.version).to match(/^\d+\.\d+\.\d+$/)
    end
  end
end
