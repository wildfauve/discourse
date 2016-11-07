require "dry-types"

module Types
  include Dry::Types.module
end

require "dry-struct"
require "stoplight"
require "mini_cache"
require "diplomat"
require 'ytry'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'faraday-http-cache'

module Discourse

  autoload :Version,            "discourse/version"
  autoload :DiscourseError,    "discourse/discourse_error"
  autoload :Configuration,      "discourse/configuration"
  autoload :PortException,      "discourse/port_exception"
  autoload :HttpPort,           "discourse/http_port"
  autoload :HttpChannel,        "discourse/http_channel"
  autoload :HttpConnection,     "discourse/http_connection"
  autoload :HttpResponseValue,  "discourse/http_response_value"
  autoload :HttpCacheDirectives,"discourse/http_cache_directives"
  autoload :HttpCacheDirectivesValue, "discourse/http_cache_directives_value"
  autoload :HttpCacheHandler,   "discourse/http_cache_handler"
  autoload :HttpCache,          "discourse/http_cache"
  autoload :Instrument,         "discourse/instrument"
  autoload :ServiceDiscovery,   "discourse/service_discovery"
  autoload :FakeServiceDiscovery,"discourse/fake_service_discovery"
  autoload :CircuitBreaker,     "discourse/circuit_breaker"
  autoload :Circuit,            "discourse/circuit"


  port_container = Dry::Container.new
  port_container.register("http_channel", -> {HttpChannel.new} )
  port_container.register("service_discovery", -> {Configuration.service_discovery} )
  port_container.register("http_port", -> {HttpPort.new} )
  port_container.register("http_response_value", -> {HttpResponseValue} )
  port_container.register("http_cache_directives", -> {HttpCacheDirectives.new} )
  port_container.register("http_cache_directives_value", -> {HttpCacheDirectivesValue} )
  port_container.register("http_cache_handler", -> {HttpCacheHandler.new} )
  port_container.register("http_cache", -> {Configuration.cache_store} )
  port_container.register("http_connection", -> {HttpConnection.new})
  port_container.register("circuit", -> {Circuit.new} )
  port_container.register("circuit_breaker", -> {CircuitBreaker} )

  Container = port_container

end
