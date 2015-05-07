describe GnCrossmap::ResultProcessor do
  let(:writer) { GnCrossmap::Writer.new(FILES[:output]) }
  subject { GnCrossmap::ResultProcessor.new(writer) }
end
