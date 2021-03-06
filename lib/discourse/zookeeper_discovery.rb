module Discourse

  class ZookeeperDiscovery

    KAFKA_BROKER_IDS_PATH = "/brokers/ids"

    include Logging

    def call
      return M::Maybe(nil) unless client
      M::Maybe(client).bind(kafka_broker_ids)
                      .bind(kafka_brokers)
                      .bind(parse)
                      .bind(to_broker_address)
    end

    private

    def kafka_broker_ids
      -> (client) { get_brokers_from_ids }
    end

    def get_brokers_from_ids
      begin
        ids = client.children(KAFKA_BROKER_IDS_PATH)
        ids.empty? ? M::Maybe(nil) : M::Maybe(ids)
      rescue Zookeeper::Exceptions::ZookeeperException => e
        M::Maybe(nil)
      rescue StandardError => e
        info "Zookeeper Discovery: Exception: #{e.message}"
        M::Maybe(nil)
      end
    end

    # {"listener_security_protocol_map"=>{"PLAINTEXT"=>"PLAINTEXT"},
    #  "endpoints"=>["PLAINTEXT://192.168.0.12:9092"],
    #  "jmx_port"=>-1,
    #  "host"=>"192.168.0.12",
    #  "timestamp"=>"1498435530996",
    #  "port"=>9092,
    #  "version"=>4}

    def kafka_brokers
      ->(ids) { M::Maybe(ids.map { |id| client.get("#{KAFKA_BROKER_IDS_PATH}/#{id}")[0] }
                            .flatten.delete_if(&:nil?) ) }
    end

    def to_broker_address#(broker)
      -> (brokers) { M::Maybe(brokers.map { |broker| "#{broker["host"]}:#{broker["port"]}" } ) }
    end

    def parse
      ->(data) { M::Maybe(data.map { |d| JSON.parse(d) } ) }
    end

    def broker_list
      unless configuration.config.zookeeper_broker_list
        error "Discourse::Zookeeper; zookeeper_broker_list not set"
        return
      end
      configuration.config.zookeeper_broker_list
    end

    def configuration
      IC["configuration"]
    end

    def client
      begin
        @client ||= IC["zookeeper_client"].new(broker_list) if broker_list
      rescue StandardError => e
        info "Zookeeper Discovery: Exception: #{e.message}"
        nil
      end
    end

  end

end
