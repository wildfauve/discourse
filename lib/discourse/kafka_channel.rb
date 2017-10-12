module Discourse

  class KafkaChannel

    include Logging

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
        result = connection.publish
        # returns a Maybe Monad, so, we'll throw an exception as this is the interface expected.
        # raise self.class::RemoteServiceError.new(msg: "failure to publish") if result.none?
      rescue Discourse::PortException => e
        debug "#{channel_to_s}; #{e}; retryable: #{e.retryable}"
        raise self.class::RemoteServiceError.new(msg: e.message, retryable: e.retryable)
      end
    end

    def kafka_connection
      IC["kafka_connection"]
    end

    def channel_to_s
      "KafkaChannel: #{topic}"
    end

  end
end
