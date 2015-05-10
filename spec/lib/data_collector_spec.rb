describe GnCrossmap::DataCollector do
  subject { GnCrossmap::DataCollector.new }

  describe ".new" do
    it "initializes" do
      expect(subject).to be_kind_of GnCrossmap::DataCollector
    end
  end

  describe "#process_row" do
    context "all fields" do
      let(:fields) do
        %w(TaxonId kingdom subkingdom phylum subphylum superclass class
           subclass cohort superorder order suborder infraorder superfamily
           family subfamily tribe subtribe genus subgenus section species
           subspecies variety form ScientificNameAuthorship)
      end
      let(:data) do
        ["142803", "Animalia", "", "Tardigrada", "", "", "Eutardigrada", "",
         "", "", "Parachela", "", "", "Macrobiotoidea", "Macrobiotidae", "",
         "", "", "Macrobiotus", "", "", "voronkovi", "", "", "",
         "Tumanov, 2007"]
      end

      context "normal" do
        it "creates fields and returns data" do
          subject.process_row(fields)
          subject.process_row(data)
          expect(subject.data).to eq(
            [{ id: "142803", name: "Macrobiotus voronkovi Tumanov, 2007",
               rank: "species" }])
        end
      end

      context "missing taxonid" do
        let(:data) do
          ["", "Animalia", "", "Tardigrada", "", "", "Eutardigrada", "",
           "", "", "Parachela", "", "", "Macrobiotoidea", "Macrobiotidae", "",
           "", "", "Macrobiotus", "", "", "voronkovi", "", "", "",
           "Tumanov, 2007"]
        end

        it "does not generate row" do
          subject.process_row(fields)
          subject.process_row(data)
          expect(subject.data).to be_empty
        end
      end

      context "no rank" do
        let(:fields) do
          %w(TaxonId kkingdom ssubkingdom pphylum ssubphylum ssuperclass cclass
             ssubclass ccohort ssuperorder oorder ssuborder iinfraorder
             ssuperfamily ffamily ssubfamily ttribe ssubtribe ggenus ssubgenus
             ssection sspec ssubspecies vvariety fform ScientificNameAuthorship)
        end
        it "does not generate row" do
          subject.process_row(fields)
          subject.process_row(data)
          expect(subject.data).to be_empty
        end
      end
    end

    context "simple" do
      let(:fields) { %w(taxonid ScientificName) }
      let(:data) do
        ["142886", "Macrobiotus echinogenitus var. areolatus Murray, 1907"]
      end

      context "normal" do
        it "creates fields and returns data" do
          subject.process_row(fields)
          subject.process_row(data)
          expect(subject.data).to eq(
            [{ id: "142886",
               name: "Macrobiotus echinogenitus var. areolatus Murray, 1907",
               rank: "variety" }])
        end
      end
    end
  end
end
