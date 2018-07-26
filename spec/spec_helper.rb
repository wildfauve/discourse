$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "discourse"

require 'pry'

class TestLogger
  def debug(msg); puts "TEST LOGGER ===> #{msg}"; end
  def info(msg); puts "TEST LOGGER ===> #{msg}"; end
  def error(msg); puts "TEST LOGGER ===> #{msg}"; end
end

M = Dry::Monads

Discourse::Configuration.configure do |config|
  config.kafka_client_id = "account"
  config.logger = TestLogger.new
  config.zookeeper_broker_list = "localhost:2181"
end
