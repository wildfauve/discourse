module Discourse

  class KafkaClient

    include Logging

    class ZookeeperFailure < Discourse::PortException ; end

    def initialize
      @client = kafka_client
    end

    def client
      @client
    end

    def topics
      return M::Maybe(nil) unless client.success?

      begin
        M::Maybe(client.value_or.topics)
      rescue StandardError
        M::Maybe(nil)
      end
    end

    private

    def kafka_client
      return M::Maybe(nil) unless kafka_broker_list.some?
      @client ||= M::Maybe(client_adapter.new(seed_brokers: kafka_broker_list.value_or, client_id: configuration.config.kafka_client_id, logger: logger.configured_logger))
    end

    def kafka_broker_list
      @kafka_broker_list ||= kafka_brokers.()
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

    def client_adapter
      Kafka
    end

  end

end
