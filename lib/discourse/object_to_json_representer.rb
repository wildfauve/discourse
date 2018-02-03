module Discourse

  class ObjectToJsonRepresenter

    def call(message)
      # TODO: if it doesnt respond to #to_json
      message.to_json
    end

  end

end
