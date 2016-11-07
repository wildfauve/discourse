module Discourse

  class HttpPort

    def get(&block)
        port = http_channel
        yield port
        port.method = :get
        port
    end

    def post(&block)
      port = http_channel
      yield port
      port.method = :post
      port
    end

    def http_channel
      Container["http_channel"]
    end

  end

end