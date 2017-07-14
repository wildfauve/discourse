module Discourse

  class KafkaBrokers

    def call
      zookeeper.()
    end

    private

    def zookeeper
      Container['zookeeper_discovery']
    end


  end

end
