module Discourse

  class DiscourseError < StandardError

    attr_reader :error_code

    def initialize(msg = "", code = nil)
      self.error_code = code
      super(msg)
    end

    def error_code=(code)
      if code
        @error_code = code
      else
        @error_code = "urn:discourse:error:#{self.class.to_s.downcase.gsub("::",":")}"
      end
    end

  end

end
