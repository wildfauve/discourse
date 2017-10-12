module Discourse

  class KafkaBrokers

    def call
      # M::Maybe(configuration.config.kafka_broker_list.split(","))
      zookeeper.()
    end

    private

    def zookeeper
      IC['zookeeper_discovery']
    end

    def configuration
      IC["configuration"]
    end

  end

end
