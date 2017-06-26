module Discourse

  class Zookeeper

    KAFKA_BROKER_IDS_PATH = "/brokers/ids"

    include Logging

    def call
      kafka_broker_ids.map { | id   | client.get("#{KAFKA_BROKER_IDS_PATH}/#{id}") }
                      .map { |data  | JSON.parse(data.first) }
                      .map { |broker| to_broker_address(broker) }
    end

    private

    # {"listener_security_protocol_map"=>{"PLAINTEXT"=>"PLAINTEXT"},
    #  "endpoints"=>["PLAINTEXT://192.168.0.12:9092"],
    #  "jmx_port"=>-1,
    #  "host"=>"192.168.0.12",
    #  "timestamp"=>"1498435530996",
    #  "port"=>9092,
    #  "version"=>4}
    def to_broker_address(broker)
      "#{broker["host"]}:#{broker["port"]}"
    end

    def kafka_broker_ids
      client.children(KAFKA_BROKER_IDS_PATH)
    end

    def broker_list
      unless configuration.config.zookeeper_broker_list
        debug "Discourse::Zookeeper; zookeeper_broker_list not set"
        return
      end
      configuration.config.zookeeper_broker_list
    end

    def configuration
      Container["configuration"]
    end

    def client
      @client ||= Container["zookeeper_client"].new(broker_list) if broker_list
    end

  end

end
