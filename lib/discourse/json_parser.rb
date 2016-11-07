module Discourse

  class JsonParser

    def call(body)
      JSON.parse(body)
    end

  end

end
