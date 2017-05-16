module Discourse

  class KafkaConnection

    def connection(topic:, event:, partition_key:)
      @topic = topic
      @event = event
      @partition_key = partition_key
      self
    end

    def publish
      kafka_client.deliver_message(@event, topic: @topic, partition_key: @partition_key)
    end

    private

    def kafka_client
      configuration.config.kafka_client
    end

    def configuration
      Container["configuration"]
    end

  end

end
