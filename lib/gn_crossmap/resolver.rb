module GnCrossmap
  # Sends data to GN Resolver and collects results
  class Resolver
    URL = "http://resolver.globalnames.org/name_resolvers.json".freeze

    def initialize(writer, data_source_id)
      @stats = { total: 0, current: 0, start_time: nil, last_batch_time: nil,
                 matches: match_types }
      @processor = GnCrossmap::ResultProcessor.new(writer, @stats)
      @ds_id = data_source_id
      @count = 0
      @current_data = {}
      @batch = 200
    end

    def resolve(data)
      @stats[:total] = data.size
      @stats[:start_time] = Time.now
      data.each_slice(@batch) do |slice|
        with_log do
          names = collect_names(slice)
          remote_resolve(names)
          yield(@stats) if block_given?
        end
      end
      @processor.writer.close
    end

    private

    def match_types
      matches = GnCrossmap::ResultProcessor::MATCH_TYPES.keys
      matches.each_with_object({}) do |key, obj|
        obj[key] = 0
      end
    end

    def with_log
      s = @count + 1
      @count += @batch
      e = [@count, @stats[:total]].min
      GnCrossmap.log("Resolve #{s}-#{e} out of #{@stats[:total]} records")
      yield
    end

    def collect_names(slice)
      @current_data = {}
      slice.each_with_object("") do |row, str|
        @current_data[row[:id]] = row[:original]
        @processor.input[row[:id]] = { rank: row[:rank] }
        str << "#{row[:id]}|#{row[:name]}\n"
      end
    end

    def remote_resolve(names)
      batch_start = Time.now
      res = RestClient.post(URL, data: names, data_source_ids: @ds_id)
      @processor.process(res, @current_data)
    rescue RestClient::Exception
      single_remote_resolve(names)
    ensure
      @stats[:last_batch_time] = Time.now - batch_start
    end

    def single_remote_resolve(names)
      names.split("\n").each do |name|
        begin
          res = RestClient.post(URL, data: name, data_source_ids: @ds_id)
          @processor.process(res, @current_data)
        rescue RestClient::Exception => e
          process_resolver_error(e, name)
          next
        end
      end
    end

    def process_resolver_error(err, name)
      @stats[:matches][7] += 1
      @stats[:current] += 1
      GnCrossmap.logger.error("Resolver broke on '#{name}': #{err.message}")
    end
  end
end
