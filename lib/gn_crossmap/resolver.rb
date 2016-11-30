module GnCrossmap
  # Sends data to GN Resolver and collects results
  class Resolver
    URL = "http://resolver.globalnames.org/name_resolvers.json".freeze

    def initialize(writer, data_source_id, stats)
      @stats = stats
      @processor = GnCrossmap::ResultProcessor.new(writer, @stats)
      @ds_id = data_source_id
      @count = 0
      @current_data = {}
      @batch = 200
    end

    def resolve(data)
      update_stats(data.size)
      data.each_slice(@batch) do |slice|
        with_log do
          names = collect_names(slice)
          remote_resolve(names)
          yield(@stats.stats) if block_given?
        end
      end
      wrap_up
    end

    private

    def wrap_up
      @stats.stats[:resolution_stop] = Time.now
      @stats.stats[:status] = :finish
      @processor.writer.close
    end

    def update_stats(records_num)
      @stats.stats[:total_records] = records_num
      @stats.stats[:resolution_start] = Time.now
      @stats.stats[:status] = :resolution
    end

    def with_log
      s = @count + 1
      @count += @batch
      e = [@count, @stats.stats[:total_records]].min
      GnCrossmap.log("Resolve #{s}-#{e} out of " \
                     "#{@stats.stats[:total_records]} records")
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
      update_batch_times(batch_start)
    end

    def update_batch_times(batch_start)
      s = @stats.stats
      s[:last_batches_time].shift if s[:last_batches_time].size > 2
      s[:last_batches_time] << Time.now - batch_start
      s[:resolution_span] = Time.now - s[:resolution_start]
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
      @stats.stats[:matches][7] += 1
      @stats.stats[:resolved_records] += 1
      GnCrossmap.logger.error("Resolver broke on '#{name}': #{err.message}")
    end
  end
end
