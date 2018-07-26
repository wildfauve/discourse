module Discourse

  class KafkaBrokers

    def call
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
