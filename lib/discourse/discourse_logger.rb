module Discourse

  class DiscourseLogger

    def call(level, message)
      logger.send(level, message) if ( logger && logger.respond_to?(level) )
    end

    def configured_logger
      logger
    end

    private

    def logger
      @logger ||= configuration.config.logger
    end

    def configuration
      IC["configuration"]
    end

  end

end
