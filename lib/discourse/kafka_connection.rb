module Discourse

  class KafkaConnection

    include Logging

    class ZookeeperFailure < Discourse::PortException ; end

    def connection(topic:, event:, partition_key:)
      @topic = topic
      @event = event
      @partition_key = partition_key
      self
    end

    def publish
      client = kafka_client

      unless client.some?
        debug "Discourse::KafkaConnection#publish Zookeeper connection failure, client: #{client.value}"
        raise self.class::ZookeeperFailure.new(msg: "Zookeeper connection failure", retryable: false) unless client.some?
      end
      client.value.deliver_message(@event, topic: @topic, partition_key: @partition_key)
    end

    private

    def kafka_client
      return M::Maybe(nil) unless kafka_broker_list.some?
      @client ||= M::Maybe(client.new(seed_brokers: kafka_broker_list.value, client_id: configuration.config.kafka_client_id))
    end

    def kafka_broker_list
      @kafka_broker_list ||= kafka_brokers.()
    end

    def kafka_brokers
      IC["kafka_brokers"]
    end

    def configuration
      IC["configuration"]
    end

    def client
      IC["kafka_client"]
    end

  end

end
