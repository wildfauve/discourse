module Discourse

  class HttpConnection

    def connection(address, encoding, cache_store = nil, instrumenter = nil)
      begin
        caching = cache_options(cache_store, instrumenter)
        connection = Faraday.new(:url => address) do |faraday|
          faraday.use :http_cache, caching if caching
          faraday.request  encoding if encoding
          faraday.response :logger
          faraday.adapter  :typhoeus
        end
        connection
      rescue Exception => e
        binding.pry
      end
    end

    def cache_options(cache_store, instrumenter)
      options = {}
      options[:store] = cache_store if cache_store
      options[:instrumenter] = instrumenter if instrumenter
      options
    end


  end

end
