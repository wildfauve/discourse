module Discourse

  class KafkaConnection

    def connection(topic:, event:, partition_key:)
      @topic = topic
      @event = event
      @partition_key = partition_key
      self
    end

    def publish
      client = kafka_client
      return unless client
      client.deliver_message(@event, topic: @topic, partition_key: @partition_key)
    end

    private

    def kafka_client
      return nil unless broker_list && configuration.config.kafka_client_id
      @client ||= client.new(seed_brokers: broker_list, client_id: configuration.config.kafka_client_id)
    end

    def broker_list
      return nil unless configuration.config.kafka_broker_list
      configuration.config.kafka_broker_list.instance_of?(Array) ? configuration.config.kafka_broker_list : configuration.config.kafka_broker_list.split(",")
    end

    def configuration
      Container["configuration"]
    end

    def client
      Container["kafka_client"]
    end

  end

end
