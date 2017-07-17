module Discourse

  class CircuitBreaker

    include Logging

    class CircuitOpen < PortException ; end
    class CircuitUnavailable < PortException ; end

    MAX_RETRIES = 3

    attr_accessor :service_name

    def initialize()
      # redis = Redis.new
      # datastore = Stoplight::DataStore::Redis.new(redis)
      # Stoplight::Light.default_data_store = datastore
    end

    def call(&block)
      circuit = Stoplight(service_name) { block.call }.with_threshold(MAX_RETRIES).with_cool_off_time(10)
      result = nil
      begin
        result = circuit.run
      rescue ServiceDiscovery::ServiceDiscoveryNotAvailable => e
        debug "#{circuit_to_s}; Service Discovery unavailable"
        raise self.class::CircuitUnavailable.new(msg: e.cause)
      rescue Stoplight::Error::RedLight => e
        debug "#{circuit_to_s}; Service: #{service_name} circuit red"
        raise self.class::CircuitOpen.new(msg: "Circuit Set to Red")
      rescue PortException => e
        debug "#{circuit_to_s}; Exception Circuit Color==> #{circuit.color} #{e.inspect}"
        raise e unless e.retryable
        if circuit.color == Stoplight::Color::RED
          raise self.class::CircuitOpen.new(msg: e.cause)
        else
          retry
        end
      end
      result
    end

    def get_info(light)
      Stoplight::Light.default_data_store.get_all(light)
    end

    def rundownred(light)
      until light.color == "green"
        debug "#{circuit_to_s}; Current Circuit Colour#{light.color}"
      end
    end

    def circuit_to_s
      "Circuit: #{service_name}"
    end

  end

end
