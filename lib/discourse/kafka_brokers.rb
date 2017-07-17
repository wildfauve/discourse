module Discourse

  class KafkaBrokers

    def call
      M::Maybe(configuration.config.kafka_broker_list.split(","))
      # zookeeper.()
    end

    private

    # def zookeeper
    #   Container['zookeeper_discovery']
    # end

    def configuration
      Container["configuration"]
    end

  end

end
