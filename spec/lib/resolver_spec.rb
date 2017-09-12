describe GnCrossmap::Resolver do
  let(:original_fields) do
    %w(TaxonId kingdom subkingdom phylum subphylum superclass class subclass
       cohort superorder order suborder infraorder superfamily family
       subfamily tribe subtribe genus subgenus section species subspecies
       variety form ScientificNameAuthorship)
  end
  let(:opts) { GnCrossmap.opts_struct({}) }
  let(:writer) do
    GnCrossmap::Writer.new(io(FILES[:output], "w:utf-8"),
                           original_fields,
                           FILES[:output])
  end
  subject { GnCrossmap::Resolver.new(writer, opts) }

  describe ".new" do
    it "creates an instance" do
      expect(subject).to be_kind_of GnCrossmap::Resolver
    end
  end

  describe "#resolve" do
    let(:data) do
      GnCrossmap::Reader.new(io(FILES[:all_fields]),
                             FILES[:all_fields], true, [], opts.stats).
        read
    end

    it "resolves names and writes them into output file" do
      expect(subject.resolve(data))
    end

    context "Resolver sends 500 error" do
      let(:data) do
        GnCrossmap::Reader.new(io(FILES[:all_fields_tiny]),
                               FILES[:all_fields_tiny],
                               opts.skip_original, [], opts.stats).read
      end

      it "exits with an error log" do
        allow(RestClient).to receive(:post) { raise RestClient::Exception }
        allow(GnCrossmap).to receive(:log) {}
        expect(subject.resolve(data))
      end
    end
  end
end
