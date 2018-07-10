module Discourse

  class HttpPort

    def get(&block)
        port = http_channel
        yield port
        port.method = :get
        port
    end

    def put(&block)
        port = http_channel
        yield port
        port.method = :put
        port
    end

    def post(&block)
      port = http_channel
      yield port
      port.method = :post
      port
    end

    def delete(&block)
      port = http_channel
      yield port
      port.method = :delete
      port
    end


    def http_channel
      IC["http_channel"]
    end

  end

end
