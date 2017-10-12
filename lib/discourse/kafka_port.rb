module Discourse

  class KafkaPort

    def send(&block)
      port = kafka_channel
      yield port
      port
    end

    def kafka_channel
      IC["kafka_channel"]
    end

  end

end
