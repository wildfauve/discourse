module Discourse

  class FakeServiceDiscovery

    def call(service:)
      service
    end

  end

end
