require "spec_helper"

describe Discourse::KafkaChannel do

  context 'problems finding brokers' do

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
