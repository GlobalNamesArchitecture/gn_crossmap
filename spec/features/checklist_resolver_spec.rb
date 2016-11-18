describe "resolving variety of csv files" do
  %i(all_fields sciname sciname_auth sciname_rank).each do |input|
    context input do
      it "resolves #{input}" do
        output = "/tmp/#{input}-processed.csv"
        input = FILES[input]
        FileUtils.rm(output) if File.exist?(output)
        GnCrossmap.run(input, output, 1, true)
        expect(File.exist?(output)).to be true
      end
    end
  end
end
