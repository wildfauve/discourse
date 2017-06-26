module Discourse

  class KafkaChannel

    class RemoteServiceError < PortException ; end
    class DirectiveError < PortException ; end

    attr_accessor :topic, :event, :partition_key

    def call()
      raise self.class::DirectiveError if event.nil?
      to_port()
    end

    private

    def to_port()
      begin
        connection = kafka_connection.connection(topic: topic, event: event.to_json, partition_key: partition_key)
        connection.publish
      rescue  => e  # Kafka::ConnectionError
        debug "#{channel_to_s}; #{e}"
        raise self.class::RemoteServiceError.new(msg: e.cause)
      end
    end

    def kafka_connection
      Container["kafka_connection"]
    end

    def debug(message)
      logger.(:debug, message)
    end

    def logger
      Container["logger"]
    end

    def channel_to_s
      "KafkaChannel: #{topic}"
    end

  end
end
