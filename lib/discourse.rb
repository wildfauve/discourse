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
require 'zk'
require 'dry-monads'

module Discourse

  port_container = Dry::Container.new
  port_container.register("kafka_channel", -> { KafkaChannel.new } )
  port_container.register("kafka_connection", -> { KafkaConnection.new } )
  port_container.register("kafka_brokers", -> { KafkaBrokers.new } )
  port_container.register("kafka_client", -> { Kafka } )
  port_container.register("zookeeper_discovery", -> { ZookeeperDiscovery.new } )
  port_container.register("zookeeper_client", -> { ZK } )
  port_container.register("http_channel", -> { HttpChannel.new } )
  port_container.register("configuration", -> { Configuration } )
  port_container.register("service_discovery", -> { IC["configuration"].config.service_discovery } )
  port_container.register("http_port", -> { HttpPort.new } )
  port_container.register("kafka_port", -> { KafkaPort.new } )
  port_container.register("http_response_value", -> { HttpResponseValue } )
  port_container.register("http_cache", -> { IC["configuration"].config.cache_store } )
  port_container.register("http_connection", -> { HttpConnection.new })
  port_container.register("json_parser", -> { JsonParser.new })
  port_container.register("xml_parser", -> { XmlParser.new })
  port_container.register("html_parser", -> { HtmlParser.new })
  port_container.register("circuit", -> { Circuit.new } )
  port_container.register("circuit_breaker", -> { CircuitBreaker } )
  port_container.register("logger", -> { DiscourseLogger.new } )

  IC = port_container

  autoload :Version,            "discourse/version"
  autoload :DiscourseError,     "discourse/discourse_error"
  autoload :Configuration,      "discourse/configuration"
  autoload :PortException,      "discourse/port_exception"
  autoload :HttpPort,           "discourse/http_port"
  autoload :KafkaPort,          "discourse/kafka_port"
  autoload :HttpChannel,        "discourse/http_channel"
  autoload :KafkaChannel,       "discourse/kafka_channel"
  autoload :KafkaConnection,    "discourse/kafka_connection"
  autoload :KafkaBrokers,       "discourse/kafka_brokers"
  autoload :ZookeeperDiscovery, "discourse/zookeeper_discovery"
  autoload :HttpConnection,     "discourse/http_connection"
  autoload :HttpResponseValue,  "discourse/http_response_value"
  autoload :HttpCache,          "discourse/http_cache"
  autoload :JsonParser,         "discourse/json_parser"
  autoload :XmlParser,          "discourse/xml_parser"
  autoload :HtmlParser,         "discourse/html_parser"
  autoload :Instrument,         "discourse/instrument"
  autoload :ServiceDiscovery,   "discourse/service_discovery"
  autoload :FakeServiceDiscovery,"discourse/fake_service_discovery"
  autoload :CircuitBreaker,     "discourse/circuit_breaker"
  autoload :Circuit,            "discourse/circuit"
  autoload :DiscourseLogger,    "discourse/discourse_logger"
  autoload :Logging,            "discourse/logging"

  M = Dry::Monads

end
