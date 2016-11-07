module Discourse

  class HttpCache

    # This is a rudimentary cache that supports the interface required by Faraday cache middleware
    # Dont use this in production.
    def initialize(options = {})
      @store_hash = {}
      @options = options
      @refresh_in = @options.fetch(:refresh_in) { Float::INFINITY }
    end

    def write(key, value)
      @store_hash[key.to_sym] = value
    end

    def read(key)
      value_hash = @store_hash[key.to_sym]
    end

    def delete(key)
      @store_hash.delete(key.to_sym)
    end

  end

end
