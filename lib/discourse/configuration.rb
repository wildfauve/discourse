module Discourse

  class ConfigurationError < DiscourseError ; end

  class Config < OpenStruct ; end

  class Configuration

    DEFAULT_SERVICE_DISCOVERY = FakeServiceDiscovery
    DEFAULT_CACHE_STORE = HttpCache.new

    class << self

      def build(&block)
        block.call self
        self
      end

      def reset!
        @config = nil
      end

      def config
        @config ||= Discourse::Config.new
      end

      def cache_store=(klass)
        config.cache_store = klass
      end

      def cache_store
        config.cache_store.nil? ? DEFAULT_CACHE_STORE : config.cache_store
      end


      def service_discovery=(klass)
        config.service_discovery = klass
      end

      def service_discovery
        config.service_discovery.nil? ? DEFAULT_SERVICE_DISCOVERY : config.service_discovery
      end

      def type_parsers=(parsers)
        config.type_parsers = parsers
      end

      def type_parsers
        config.type_parsers || {}
      end


    end # class << self

  end  # clas Configuration

end  # module ScoreCard
