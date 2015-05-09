module GnCrossmap
  # Sends data to GN Resolver and collects results
  class Resolver
    URL = "http://resolver.globalnames.org/name_resolvers.json"

    def initialize(writer, data_source_id)
      @processor = GnCrossmap::ResultProcessor.new(writer)
      @ds_id = data_source_id
      @count = 0
      @batch = 200
    end

    def resolve(data)
      data_size = data.size
      data.each_slice(@batch) do |slice|
        with_log(data_size) do
          names = collect_names(slice)
          remote_resolve(names)
        end
      end
      @processor.writer.close
    end

    private

    def with_log(size)
      s = @count + 1
      @count += @batch
      e = [@count, size].min
      GnCrossmap.log("Resolve #{s}-#{e} out of #{size} records")
      yield
    end

    def collect_names(slice)
      slice.each_with_object("") do |row, str|
        @processor.input[row[:id]] = { rank: row[:rank] }
        str << "#{row[:id]}|#{row[:name]}\n"
      end
    end

    def remote_resolve(names)
      res = RestClient.post(URL, data: names, data_source_ids: @ds_id)
      @processor.process(res)
    rescue RestClient::Exception
      single_remote_resolve(names)
    end

    def single_remote_resolve(names)
      names.split("\n").each do |name|
        begin
          res = RestClient.post(URL, data: name, data_source_ids: @ds_id)
          @processor.process(res)
        rescue RestClient::Exception => e
          GnCrossmap.log("Resolver broke on '#{name}': #{e}")
          next
        end
      end
    end
  end
end
