require "spec_helper"
require 'dry/container/stub'

describe Discourse::KafkaChannel do

  context 'publishing' do

      before do
        class ClientDouble
          def initialize(*args) ; self ; end
          def client ; M.Maybe(self) ; end
          def deliver_message(*args); nil ; end
        end

        Discourse::IC.enable_stubs!
        Discourse::IC.stub('kafka_client', ClientDouble)
      end

      after do
        Discourse::IC.unstub('kafka_client')
      end

    it 'publishes like a happy bunny' do

      expect_any_instance_of(ClientDouble).to receive(:deliver_message)
      
      result = Discourse::KafkaPort.new.send do |p|
        p.topic = "io.mindainfo.account.transaction"
        p.event = { kind: :event }
        p.partition_key = "123"
      end.()

    end
  end

  context 'problems finding brokers' do

    before do
      class ConnectionDouble
        def connection(*args) ; self ; end
        def publish(*args)
          raise Discourse::KafkaConnection::ZookeeperFailure.new(msg: "Zookeeper connection failure", retryable: false)
        end
      end

      Discourse::IC.enable_stubs!
      Discourse::IC.stub('kafka_connection', ConnectionDouble)
    end

    after do
      Discourse::IC.unstub('kafka_connection')
    end

    it 'should return a none' do

      channel = Discourse::KafkaPort.new.send do |p|
        p.topic = "topic"
        p.event = { kind: :event }
        p.partition_key = "123"
      end

      expect { channel.() }.to raise_error(Discourse::KafkaChannel::RemoteServiceError)

    end

  end

end
