require "spec_helper"
require 'dry/container/stub'

describe Discourse::KafkaChannel do

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
