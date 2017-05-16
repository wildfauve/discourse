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
require 'ruby-kafka'

module Discourse

  autoload :Version,            "discourse/version"
  autoload :DiscourseError,     "discourse/discourse_error"
  autoload :Configuration,      "discourse/configuration"
  autoload :PortException,      "discourse/port_exception"
  autoload :HttpPort,           "discourse/http_port"
  autoload :KafkaPort,          "discourse/kafka_port"
  autoload :HttpChannel,        "discourse/http_channel"
  autoload :KafkaChannel,       "discourse/kafka_channel"
  autoload :KafkaConnection,    "discourse/kafka_connection"
  autoload :HttpConnection,     "discourse/http_connection"
  autoload :HttpResponseValue,  "discourse/http_response_value"
  autoload :HttpCache,          "discourse/http_cache"
  autoload :JsonParser,         "discourse/json_parser"
  autoload :HtmlParser,         "discourse/html_parser"
  autoload :Instrument,         "discourse/instrument"
  autoload :ServiceDiscovery,   "discourse/service_discovery"
  autoload :FakeServiceDiscovery,"discourse/fake_service_discovery"
  autoload :CircuitBreaker,     "discourse/circuit_breaker"
  autoload :Circuit,            "discourse/circuit"


  port_container = Dry::Container.new
  port_container.register("http_channel", -> { HttpChannel.new } )
  port_container.register("kafka_channel", -> { KafkaChannel.new } )
  port_container.register("kafka_connection", -> { KafkaConnection.new } )
  port_container.register("configuration", -> { Configuration } )
  port_container.register("service_discovery", -> { Container["configuration"].service_discovery } )
  port_container.register("http_port", -> { HttpPort.new } )
  port_container.register("kafka_port", -> { KafkaPort.new } )
  port_container.register("http_response_value", -> { HttpResponseValue } )
  port_container.register("http_cache", -> { Container["configuration"].cache_store } )
  port_container.register("http_connection", -> { HttpConnection.new })
  port_container.register("json_parser", -> { JsonParser.new })
  port_container.register("html_parser", -> { HtmlParser.new })
  port_container.register("circuit", -> { Circuit.new } )
  port_container.register("circuit_breaker", -> { CircuitBreaker } )

  Container = port_container

end
