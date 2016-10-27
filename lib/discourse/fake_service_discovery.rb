module Discourse

  class FakeServiceDiscovery

    def find(service:, environment:)
      "http://localhost:5000/"
    end

  end

end
