require "dry-types"

module Types
  include Dry::Types.module
end

require "dry-struct"
require "stoplight"
require "mini_cache"
require "diplomat"
require 'ytry'

module Discourse

  autoload :Version,            "discourse/version"
  autoload :PortException,      "discourse/port_exception"
  autoload :HttpPort,           "discourse/http_port"
  autoload :HttpChannel,        "discourse/http_channel"
  autoload :HttpResponseValue,  "discourse/http_response_value"
  autoload :HttpCacheDirectives,"discourse/http_cache_directives"
  autoload :HttpCacheDirectivesValue, "discourse/http_cache_directives_value"
  autoload :HttpCache,          "discourse/http_cache"
  autoload :ServiceDiscovery,   "discourse/service_discovery"
  autoload :FakeServiceDiscovery,"discourse/fake_service_discovery"
  autoload :CircuitBreaker,     "discourse/circuit_breaker"
  autoload :Circuit,            "discourse/circuit"


  port_container = Dry::Container.new
  port_container.register("http_channel", -> {HttpChannel.new} )
  port_container.register("service_discovery", -> {FakeServiceDiscovery} )
  port_container.register("http_port", -> {HttpPort.new} )
  port_container.register("http_response_value", -> {HttpResponseValue} )
  port_container.register("http_cache_directives", -> {HttpCacheDirectives.new} )
  port_container.register("http_cache_directives_value", -> {HttpCacheDirectivesValue} )
  port_container.register("http_cache", -> {HttpCache.new} )
  port_container.register("circuit", -> {Circuit.new} )
  port_container.register("circuit_breaker", -> {CircuitBreaker} )

  Container = port_container

end
