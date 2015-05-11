describe GnCrossmap::Collector do
  context "name assembled from columns" do
    let(:fields) do
      %i(taxonid kingdom subkingdom phylum subphylum superclass class
         subclass cohort superorder order suborder infraorder superfamily
         family subfamily tribe subtribe genus subgenus section species
         subspecies variety form scientificnameauthorship)
    end
    subject { GnCrossmap::Collector.new }

    describe ".new" do
      it "initializes" do
        expect(subject).to be_kind_of GnCrossmap::Collector
      end
    end

    describe "#process_row" do
      let(:row) do
        ["142803", "Animalia", "", "Tardigrada", "", "", "Eutardigrada", "",
         "", "", "Parachela", "", "", "Macrobiotoidea", "Macrobiotidae", "",
         "", "", "Macrobiotus", "", "", "voronkovi", "", "", "",
         "Tumanov, 2007"]
      end

      context "normal" do
        it "creates fields and returns data" do
          subject.process_row(fields)
          subject.process_row(row)
          expect(subject.data).to eq(
            [{ id: "142803", name: "Macrobiotus voronkovi Tumanov, 2007",
               rank: "species" }])
        end
      end

      context "missing taxonid" do
        let(:row) do
          ["", "Animalia", "", "Tardigrada", "", "", "Eutardigrada", "",
           "", "", "Parachela", "", "", "Macrobiotoidea", "Macrobiotidae", "",
           "", "", "Macrobiotus", "", "", "voronkovi", "", "", "",
           "Tumanov, 2007"]
        end

        it "does not generate row" do
          subject.process_row(fields)
          subject.process_row(row)
          expect(subject.data).to be_empty
        end
      end

      context "no rank" do
        let(:fields) do
          %i(taxonid kkingdom ssubkingdom pphylum ssubphylum ssuperclass cclass
             ssubclass ccohort ssuperorder oorder ssuborder iinfraorder
             ssuperfamily ffamily ssubfamily ttribe ssubtribe ggenus ssubgenus
             ssection sspec ssubspecies vvariety fform scientificnameauthorship)
        end
        it "does not generate row" do
          subject.process_row(fields)
          subject.process_row(row)
          expect(subject.data).to be_empty
        end
      end
    end
  end

  context "name taken from scientificname field" do
    context "fields: taxonid scientificname" do
      let(:fields) { %w(taxonid ScientificName) }
      let(:row) do
        ["142886", "Macrobiotus echinogenitus var. areolatus Murray, 1907"]
      end

      it "creates fields and returns data" do
        subject.process_row(fields)
        subject.process_row(row)
        expect(subject.data).to eq(
          [{ id: "142886",
             name: "Macrobiotus echinogenitus var. areolatus Murray, 1907",
             rank: "variety" }])
      end
    end

    context "fields: taxonid scientificname scientificnameauthorship" do
      let(:fields) { %w(taxonid ScientificName scientificNameAuthorship) }
      let(:row) do
        ["142886", "Macrobiotus echinogenitus var. areolatus", "Murray, 1907"]
      end

      it "creates fields and returns data" do
        subject.process_row(fields)
        subject.process_row(row)
        expect(subject.data).to eq(
          [{ id: "142886",
             name: "Macrobiotus echinogenitus var. areolatus Murray, 1907",
             rank: "variety" }])
      end
    end
  end
end
