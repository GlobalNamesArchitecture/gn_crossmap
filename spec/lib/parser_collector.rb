describe GnCrossmap::ParserCollector do
  subject { GnCrossmap::ParserCollector.new(fields) }

  context "taxonid scientificname" do
    let(:fields) { %w(taxonid ScientificName) }
    let(:row) do
      ["142886", "Macrobiotus echinogenitus var. areolatus Murray, 1907"]
    end

    it "creates fields and returns data" do
      subject.process_row(row)
      expect(subject.data).to eq(
        [{ id: "142886",
           name: "Macrobiotus echinogenitus var. areolatus Murray, 1907",
           rank: "variety" }])
    end
  end
end
