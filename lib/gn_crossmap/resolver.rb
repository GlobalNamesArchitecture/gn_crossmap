module GnCrossmap
  # Sends data to GN Resolver and collects results
  class Resolver
    URL = "http://resolver.globalnames.org/name_resolvers.json"

    def initialize(writer, data_source_id)
      @processor = GnCrossmap::ResultProcessor.new(writer)
      @ds_id = data_source_id
    end

    def resolve(data)
      data.each_slice(200) do |slice|
        names = collect_names(slice)
        remote_resolve(names)
      end
    end

    private

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
          puts e, name
          next
        end
      end
    end
  end
end
