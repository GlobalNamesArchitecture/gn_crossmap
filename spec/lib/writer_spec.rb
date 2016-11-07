describe GnCrossmap::Writer do
  let(:output) { io(FILES[:output], "w:utf-8") }
  subject { GnCrossmap::Writer.new(output, [], FILES[:output]) }
end
