module Discourse

  module Circuit
    def self.included(base)
    end

    def with_circuit(&block)
      circuit = circuit_breaker.new
      yield circuit
      circuit
    end

    module ClassMethods
    end

    def circuit_breaker
      Discourse::Container["circuit_breaker"]
    end

  end

end
