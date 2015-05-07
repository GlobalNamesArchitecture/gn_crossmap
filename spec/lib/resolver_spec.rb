describe GnCrossmap::Resolver do
  subject { GnCrossmap::Resolver.new }

  describe ".new" do
    it "creates instance" do
      expect(subject).to be_kind_of GnCrossmap::Resolver
    end
  end
end
