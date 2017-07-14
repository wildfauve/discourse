module Discourse

  class KafkaConnection

    class ZookeeperFailure < Discourse::PortException ; end

    def connection(topic:, event:, partition_key:)
      @topic = topic
      @event = event
      @partition_key = partition_key
      self
    end

    def publish
      client = kafka_client
      raise self.class::ZookeeperFailure.new(msg: "Zookeeper connection failure", retryable: false) unless client.some?
      client.deliver_message(@event, topic: @topic, partition_key: @partition_key)
    end

    private

    def kafka_client
      return M::Maybe(nil) unless kafka_broker_list.some?
      @client ||= client.new(seed_brokers: broker_list.value, client_id: configuration.config.kafka_client_id)
    end

    def kafka_broker_list
      @kafka_broker_list ||= from_zookeeper
    end

    def from_zookeeper
      kafka_brokers.()
    end

    def kafka_brokers
      Container["kafka_brokers"]
    end

    def configuration
      Container["configuration"]
    end

    def client
      Container["kafka_client"]
    end

  end

end
