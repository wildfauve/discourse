module Discourse

  class KafkaBrokers

    def call
      zookeeper.()
    end

    private

    def zookeeper
      Container['zookeeper']
    end


  end

end
