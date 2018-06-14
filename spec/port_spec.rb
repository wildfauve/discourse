require "spec_helper"

describe Discourse::HttpPort do

  context "HTTP Port" do

    let(:faraday_request_object) { double("request") }

    let(:faraday_connection_object) { double("connection", use: faraday_request_object,
                                                           response: faraday_request_object,
                                                           adapter: faraday_request_object) }

    context "input paramaters" do

      it "should set channel parameters for method, service and resource" do

        port = Discourse::HttpPort.new.get do |p|
          p.service = "http://api.example.com"
          p.resource = "/resource"
        end

        expect(port.method).to eq :get
        expect(port.service).to eq "http://api.example.com"
        expect(port.resource).to eq "/resource"
        expect(port.port_binding).to eq "http://api.example.com/resource"

      end

      it "should use the default fake service discovery class" do

        expect(Discourse::FakeServiceDiscovery).to receive_message_chain(:new, :call)
                                               .with({service: "http://api.example.com"})
                                               .and_return("http://api.example.com/resource")

        port = Discourse::HttpPort.new.get do |p|
          p.service = "http://api.example.com"
          p.resource = "/resource"
        end

        port.port_binding
      end

      it "should raise an exception when no service is provided" do

        expect { port = Discourse::HttpPort.new.get {}.call }.to raise_exception(Discourse::HttpChannel::DirectiveError)

      end

    end

    context 'Get Requests' do

      before do
        @html_response = double("http_resp", body: '<html><body></body>', status: 200,
                                            headers: {"content-type"=>"text/html; charset=ISO-8859-1"})

        @json_response = double("http_resp", body: '{"message" : "I am json"} ', status: 200,
                                            headers: {"content-type"=>"application/json"})


      end

      it "should send a get to the port with headers and params" do

        expect(Faraday).to receive(:new).with(url: "http://api.example.com/resource").and_yield(faraday_connection_object)

        expect(faraday_request_object).to receive(:get).and_yield(faraday_request_object).and_return(@json_response)

        expect(faraday_request_object).to receive(:headers=).with({:authorization=>"uid:pwd"})
        expect(faraday_request_object).to receive(:params=).with({param1: 1})

        port = Discourse::HttpPort.new.get do |p|
          p.service = "http://api.example.com"
          p.resource = "/resource"
          p.request_headers = {authorization: "uid:pwd"}
          p.query_params = {param1: 1}
        end.call

        expect(port.body).to eq({"message"=>"I am json"})
        expect(port.status).to eq :ok

      end

      # it 'filters passwords from the logs' do
      #
      #   expect(Faraday).to receive(:new).with(url: "http://api.example.com/resource").and_yield(faraday_connection_object)
      #
      #   expect(faraday_request_object).to receive(:post).and_yield(faraday_request_object).and_return(@json_response)
      #
      #   expect(faraday_request_object).to receive(:headers=).with({:authorization=>"uid:pwd"})
      #   expect(faraday_request_object).to receive(:params=).with({param1: 1})
      #
      #   port = Discourse::HttpPort.new.post do |p|
      #     p.service = "http://api.example.com"
      #     p.resource = "/resource"
      #     p.request_headers = {authorization: "uid:pwd"}
      #     p.request_body = { username: 'test', password: 'password1' }
      #   end.call
      #
      # end


    end # context Get

  end  # context main

end
