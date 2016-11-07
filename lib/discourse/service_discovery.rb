module Discourse

  class ServiceDiscovery

    class ServiceDiscoveryNotAvailable < Discourse::PortException ; end

    SERVICE_CACHE = MiniCache::Store.new

    def call(service:)
      begin
        service_location = get_by_service_name(service)
        cache_service(service_location)
        address(service_location)
      rescue Diplomat::PathNotFound => e
        raise ServiceDiscoveryNotAvailable.new(msg: e.cause, retryable: false)
      rescue self.class::ServiceDiscoveryNotAvailable => e
        # TODO: check the cache
        raise e
      end

    end

    def get_by_service_name(service_name)
      service = Diplomat::Service.get(service_name.to_s)
      raise self.class::ServiceDiscoveryNotAvailable.new(msg: e.cause, retryable: false) if !service.respond_to? :Address
      service
    end

    def address(service)
      "http://#{service.ServiceAddress}:#{service.ServicePort}"
    end

    def cache_service(service)

    end

  end

end
