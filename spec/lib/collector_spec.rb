describe GnCrossmap::Collector do
  let(:skip_original) { false }
  subject { GnCrossmap::Collector.new(skip_original) }

  context "name assembled from columns" do
    let(:fields) do
      %i(taxonid kingdom subkingdom phylum subphylum superclass class
         subclass cohort superorder order suborder infraorder superfamily
         family subfamily tribe subtribe genus subgenus section species
         subspecies variety form scientificnameauthorship)
    end

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
               rank: "species",
               original: ["142803", "Animalia", "", "Tardigrada", "", "",
                          "Eutardigrada", "", "", "", "Parachela", "", "",
                          "Macrobiotoidea", "Macrobiotidae", "", "", "",
                          "Macrobiotus", "", "", "voronkovi", "", "", "",
                          "Tumanov, 2007"] }]
          )
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
          expect do
            subject.process_row(fields)
          end.to raise_error GnCrossmapError
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
             rank: "variety",
             original: ["142886",
                        "Macrobiotus echinogenitus var. areolatus " \
                        "Murray, 1907"] }]
        )
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
             rank: "variety", original: [
               "142886", "Macrobiotus echinogenitus var. areolatus",
               "Murray, 1907"
             ] }]
        )
      end
    end

    context "fields: no taxonid" do
      let(:fields) { %w(id ScientificName scientificNameAuthorship) }
      let(:row) do
        ["142886", "Macrobiotus echinogenitus var. areolatus", "Murray, 1907"]
      end

      it "processes the row, assigning gn uuid as id" do
        subject.process_row(fields)
        subject.process_row(row)
        expect(subject.data).to eq(
          [{ id: "4939ff2a-b709-58a4-82ed-890efa22bfdd",
             name: "Macrobiotus echinogenitus var. areolatus Murray, 1907",
             rank: "variety",
             original: ["142886", "Macrobiotus echinogenitus var. areolatus",
                        "Murray, 1907"] }]
        )
      end
    end

    context "taxonid is the only known field" do
      let(:fields) { %w(taxonid field1 field2) }
      let(:row) do
        ["142886", "Macrobiotus echinogenitus var. areolatus", "Murray, 1907"]
      end

      it "raises error" do
        expect do
          subject.process_row(fields)
        end.to raise_error GnCrossmapError
      end
    end
  end
end
