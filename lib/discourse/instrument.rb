module Discourse

  class Instrument

    # Faraday publishes an event after it has sent the request.
    # + event: ""
    # + env; which is a cut down version of the rack env hash.
    def instrument(event, env)
      # puts "Instrument: #{event}, #{env[:cache_status]}"
      nil
    end

  end

end
