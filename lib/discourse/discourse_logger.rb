module Discourse

  class DiscourseLogger

    def call(level, message)
      logger.send(level, message) if logger
    end

    private

    def logger
      configuration.config.logger
    end

    def configuration
      IC["configuration"]
    end

  end

end
