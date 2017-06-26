require "spec_helper"

describe Discourse::KafkaBrokers do

  context 'Finding Brokers in Zookeeper' do

    before do

      Discourse::Configuration.configure do |config|
        config.zookeeper_broker_list = "localhost:2181"
      end

      @node_data_0 = {
                    "listener_security_protocol_map"=>{"PLAINTEXT"=>"PLAINTEXT"},
                    "endpoints"=>["PLAINTEXT://192.168.0.12:9092"],
                    "jmx_port"=>-1,
                    "host"=>"192.168.0.12",
                    "timestamp"=>"1498435530996",
                    "port"=>9092,
                    "version"=>4
                  }.to_json

      @node_data_1 = {
                    "listener_security_protocol_map"=>{"PLAINTEXT"=>"PLAINTEXT"},
                    "endpoints"=>["PLAINTEXT://192.168.0.22:9092"],
                    "jmx_port"=>-1,
                    "host"=>"192.168.0.22",
                    "timestamp"=>"1498435530996",
                    "port"=>9092,
                    "version"=>4
                  }.to_json

      @zk_client = double("ZK", children: ["0", "1"]) #, get: [node_data, nil])

    end

    it 'should obtain a list of brokers from Zookeeper' do

      allow(ZK).to receive(:new).with("localhost:2181").and_return(@zk_client)
      allow(@zk_client).to receive(:get)
                       .with("/brokers/ids/0")
                       .and_return([@node_data_0, nil])

      allow(@zk_client).to receive(:get)
                      .with("/brokers/ids/1")
                      .and_return([@node_data_1, nil])

      brokers = Discourse::Container['kafka_brokers'].()
      expect(brokers).to eq ["192.168.0.12:9092","192.168.0.22:9092"]

    end

  end

end
