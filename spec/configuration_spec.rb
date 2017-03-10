require "spec_helper"

describe Discourse::Configuration do

  context 'Default Configuration' do

    it "should set the default service discovery to a fake version of service discovery" do
      config = Discourse::Configuration.build {}

      expect(config.service_discovery).to eq Discourse::FakeServiceDiscovery
    end

    it "should default the cache store to the base caching class" do
      config = Discourse::Configuration.build {}
      expect(config.cache_store).to be_instance_of Discourse::HttpCache
    end

  end

end
