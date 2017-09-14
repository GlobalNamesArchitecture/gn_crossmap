# frozen_string_literal: true

describe GnCrossmap::ResolverJob do
  let(:names) do
["1|Pomatomus saltator",
 "2|Puma concolor",
 "3|Monochamus galloprovincialis",
 "5|Bubo bubo",
 "6|Potentilla erecta",
 "7|Parus major"]

  end
  let(:opts) { GnCrossmap.opts_struct({}) }
  subject { GnCrossmap::ResolverJob }
  describe ".new" do
    it "creates instance" do
      expect(subject.new(names, {}, opts.resolver_url,
                         opts.data_source_id)).
             to be_kind_of GnCrossmap::ResolverJob
    end
  end

  describe "#run" do
    it "resolves names" do
      job = subject.new(names, {}, opts.resolver_url,
                        opts.data_source_id)
      res = job.run
      expect(res[0]).to be_kind_of Array
      expect(res[0].size).to eq 1
      expect(JSON.parse(res[0][0])).to be_kind_of Hash
      expect(res[1]).to be_kind_of Hash
      expect(res[1].empty?).to be true
      expect(res[2]).to be_kind_of GnCrossmap::Stats
    end
  end
end
