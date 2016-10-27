module Discourse

  class HttpCacheDirectivesValue < Dry::Struct

    attribute :caching_enabled, Types::Bool
    attribute :perform_modification_check, Types::Bool
    attribute :revalidate, Types::Bool
    attribute :cache_valid_until, Types::Time
    attribute :etag, Types::String

  end

end
