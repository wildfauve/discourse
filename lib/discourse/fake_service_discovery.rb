module Discourse

  class FakeServiceDiscovery

    # Fake Service discovery is really a non-service discovery.
    # This is done because we dont have an implementation of a Consul-based discovery mechanism
    # Hence the client MUST pass a fully resolvable URL
    def call(service:)
      service
    end

  end

end
