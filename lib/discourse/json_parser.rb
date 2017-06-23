module Discourse

  class JsonParser

    def call(body)
      return {} unless body
      JSON.parse(body)
    end

  end

end
