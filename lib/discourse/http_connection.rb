module Discourse

  class HttpConnection

    def connection(address, encoding)
      begin
        connection = Faraday.new(:url => address) do |faraday|
          faraday.request  encoding if encoding
          faraday.response :logger
          # faraday.adapter  Faraday.default_adapter
          faraday.adapter  :typhoeus
        end
        connection
      rescue Exception => e
        binding.pry
      end

    end


  end

end
