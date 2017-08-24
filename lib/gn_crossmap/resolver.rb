# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

module GnCrossmap
  # Sends data to GN Resolver and collects results
  class Resolver
    attr_reader :stats

    def initialize(writer, opts)
      instance_vars_from_opts(opts)
      @processor = GnCrossmap::ResultProcessor.
                   new(writer, @stats, @with_classification)
      @count = 0
      @jobs = []
      @batch = 200
    end

    def resolve(data)
      resolution_stats(data.size)
      @threads.times do
        batch = data.shift(@batch)
        add_job(batch)
      end
      block_given? ? traverse_jobs(data, &Proc.new) : traverse_jobs(data)
      wrap_up
      yield(@stats.stats) if block_given?
    end

    private

    def wrap_up
      @stats.stats[:resolution_stop] = Time.now
      @stats.stats[:status] = :finish
      @processor.writer.close
    end

    def add_job(batch)
      job = batch.empty? ? nil : create_job(batch)
      @jobs << job
    end

    def traverse_jobs(data)
      until data.empty? && @jobs.compact.empty?
        process_results(data)
        cmd = yield(@stats.stats) if block_given?
        break if cmd == "STOP"
        sleep(0.5)
      end
    end

    def resolution_stats(records_num)
      @stats.stats[:total_records] = records_num
      @stats.stats[:resolution_start] = Time.now
      @stats.stats[:status] = :resolution
    end

    def process_results(data)
      indices = []
      @jobs.each_with_index do |job, i|
        next if job.nil? || !job.complete?
        with_log do
          process_job(job)
          indices << i
        end
      end
      add_jobs(indices, data) unless indices.empty?
    end

    def add_jobs(indices, data)
      indices.each do |i|
        batch = data.shift(@batch)
        @jobs[i] = batch.empty? ? nil : create_job(batch)
      end
    end

    def process_job(job)
      if job.fulfilled?
        results, current_data, stats = job.value
        update_stats(stats)
        @processor.process(results, current_data)
      else
        GnCrossmap.logger.error("Remote resolver server failed")
      end
    end

    # rubocop:disable Metrics/AbcSize
    def update_stats(job_stats)
      s = @stats.stats
      s[:last_batches_time].shift if s[:last_batches_time].size > 2
      s[:last_batches_time] << job_stats.stats[:last_batches_time][0]
      s[:resolution_span] = Time.now - s[:resolution_start]
      s[:resolved_records] += job_stats.stats[:resolved_records]
      s[:matches][7] += job_stats.stats[:matches][7]
    end
    # rubocop:enable all

    def create_job(batch)
      names, batch_data = collect_names(batch)
      rb = ResolverJob.new(names, batch_data, @resolver_url, @ds_id)
      Concurrent::Future.execute { rb.run }
    end

    def instance_vars_from_opts(opts)
      @stats = opts.stats
      @with_classification = opts.with_classification.freeze
      @ds_id = opts.data_source_id.freeze
      @resolver_url = opts.resolver_url.freeze
      @threads = opts.threads
    end

    def collect_names(batch)
      batch_data = {}
      names = batch.each_with_object([]) do |row, str|
        id = row[:id].strip
        batch_data[id] = row[:original]
        @processor.input[id] = { rank: row[:rank] }
        str << "#{id}|#{row[:name]}"
      end.join("\n")
      [names, batch_data]
    end

    def with_log
      s = @count + 1
      @count += @batch
      e = [@count, @stats.stats[:total_records]].min
      GnCrossmap.log("Resolve #{s}-#{e} out of " \
                     "#{@stats.stats[:total_records]} records at " \
                     "#{@resolver_url}")
      yield
    end
  end
end
