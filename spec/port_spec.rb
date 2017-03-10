require "spec_helper"

describe Discourse::HttpPort do

  context 'Get Port' do

    before do
      @html_response = double("http_resp", body: '<html><body></body>', status: 200,
                                          headers: {"content-type"=>"text/html; charset=ISO-8859-1"})

      @json_response = double("http_resp", body: '{"message" : "I am json"} ', status: 200,
                                          headers: {"content-type"=>"application/json"})


    end

    it "should send a get to the port with headers and params" do

      request = double("request")
      connection = double("connection", use: request, response: request, adapter: request)

      allow(Faraday).to receive(:new).and_yield(connection)

      expect(request).to receive(:get).and_yield(request).and_return(@json_response)
      expect(request).to receive(:headers=).with({:authorization=>"uid:pwd"})
      expect(request).to receive(:params=).with({param1: 1})

      port = Discourse::HttpPort.new.get do |p|
        p.service = "http://api.example.com"
        p.request_headers = {authorization: "uid:pwd"}
        p.query_params = {param1: 1}
      end.call

      expect(port.body).to eq({"message"=>"I am json"})
      expect(port.status).to eq :ok



    end

  end

end
