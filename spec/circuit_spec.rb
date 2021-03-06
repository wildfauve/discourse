require "spec_helper"
require 'logger'

describe Discourse::Circuit do

  context 'Create Circuit' do

    before do

      class MockClient
        include Discourse::Circuit

        def circuit_test
          # logger = Logger.new(STDOUT)
          # logger.level = Logger::DEBUG

          with_circuit do |circuit|
            circuit.service_name = "test resource"
            # circuit.logger = logger
          end
        end
      end

      Stoplight::Light.default_data_store = Stoplight::DataStore::Memory.new

      @circuit = MockClient.new.circuit_test

    end

    it "should create a circuit breaker" do
      expect(@circuit).to be_instance_of Discourse::CircuitBreaker
    end

    it "should succeed when there is no failures" do
      circuit_result = @circuit.call { 1 / 1 }
      expect(circuit_result).to eq 1
    end

    it "should throw a service unavailable exception when service discovery is unavailable" do
      circuit = MockClient.new.circuit_test
      expect { circuit.call { raise Discourse::ServiceDiscovery::ServiceDiscoveryNotAvailable.new } }.to raise_exception(Discourse::CircuitBreaker::CircuitUnavailable)
    end


    it "should throw a circuit open exception when a port exception is raised" do
      expect { @circuit.call { raise Discourse::PortException.new } }.to raise_exception(Discourse::CircuitBreaker::CircuitOpen)
    end


  end


end
