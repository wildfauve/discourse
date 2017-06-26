module Discourse

  module Logging

    def error(message)
      logger.(:debug, message)
    end

    def debug(message)
      logger.(:debug, message)
    end

    def logger
      Container["logger"]
    end

  end

end
