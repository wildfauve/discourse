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
        info "Discourse::KafkaConnection#publish Zookeeper connection failure, client: #{client.value_or}"
        raise self.class::ZookeeperFailure.new(msg: "Zookeeper connection failure", retryable: false) unless client.some?
      end
      client.value_or.deliver_message(@event, topic: @topic, partition_key: @partition_key)
    end

    private

    def kafka_client
      client.new.client
    end

    def logger
      IC["logger"]
    end

    def kafka_brokers
      IC["kafka_brokers"]
    end

    def configuration
      IC["configuration"]
    end

    def client
      IC['kafka_client']
    end

  end

end
