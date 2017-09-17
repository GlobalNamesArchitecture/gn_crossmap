# frozen_string_literal: true

module GnCrossmap
  # Remote resolution for parallel jobs
  class ResolverJob
    def initialize(names, batch_data, resolver_url, ds_id)
      @names_size = names.size
      @names = names.join("\n")
      @batch_data = batch_data
      @resolver_url = resolver_url
      @ds_id = ds_id
      @stats = Stats.new
    end

    def run
      res = remote_resolve(@names)
      [res, @batch_data, @stats]
    end

    private

    def remote_resolve(names)
      batch_start = Time.now
      res = RestClient.post(@resolver_url, data: names,
                                           data_source_ids: @ds_id)
      [res.body]
    rescue RestClient::Exception
      single_remote_resolve(names)
    ensure
      update_stats(batch_start)
    end

    def single_remote_resolve(names)
      all_res = []
      names.split("\n").each do |name|
        res = single_post(name)
        next unless res
        all_res << res.body
      end
      all_res
    end

    def single_post
      RestClient.post(@resolver_url, data: name,
                                     data_source_ids: @ds_id)
    rescue RestClient::Exception => e
      process_resolver_error(e, name)
      nil
    end

    def process_resolver_error(err, name)
      @stats.stats[:matches][7] += 1
      GnCrossmap.logger.error("Resolver broke on '#{name}': #{err.message}")
    end

    def update_stats(batch_start)
      @stats.stats[:current_speed] = @names_size / (Time.now - batch_start)
      @stats.stats[:resolution][:completed_records] = @names_size
    end
  end
end
