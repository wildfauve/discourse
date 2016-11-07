# Discourse

Discourse is a little platform gem that provides a wrapper around HTTP and other services like:
+ Circuit breaker (using the [Stoplight Gem](https://github.com/orgsync/stoplight))
+ Service discovery (using Consul, and the [Diplomat Gem](https://github.com/WeAreFarmGeek/diplomat)); but you'll need Consul deployed.  But you can inject your own implementation.
+ Multiple HTTP requests
+ Even some caching, using the Faraday middleware (the [Faraday caching extension](https://github.com/plataformatec/faraday-http-cache)); although this doesn't really work yet. But you can add your own.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'discourse'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install discourse


To experiment with that code, run `bin/console` for an interactive prompt.


## Usage

### Configuration

Discourse supports the injection of alternate classes/objects for key functions like service discovery or cache store.  Both of these have a default implementation, however, if you have your own, then just inject them into the config.

```ruby
Discourse::Configuration.build do |config|
  config.service_discovery = Discourse::FakeServiceDiscovery              # The default for Discourse
  config.cache_store = Discourse::HttpCache.new                           # The default Object for Caching
  config.type_parsers = {"application/json" => Discourse::JsonParser.new} # The default JSON Parser
end
```

** Service Discovery**

The `service_discovery` objects (or classes) must implement a `call` method, the `service` provided in the actual Discourse HTTP call is provided, and service discovery MUST return a fully qualified URL.  The `resource` is appended to the URL to produce the final URL (hostname + resource)

The `FakeServiceDiscovery` class does absolutely nothing.  Apart from reflecting back the `service` parameter on the HTTP call.

** Cache Store**

** Type Parsers **

Discourse only supports the `text/html` and `application/json` media_types.  But you can add your own by providing Discourse with a hash in the `{media_type => Object}` format.  Your object must respond to a `call`, will be provided with a single argument containing the HTTP response body, and it can return an type of Ruby object.

So, for instance:

```ruby
Discourse::Configuration.build do |config|
  config.type_parsers = {"application/json" => FantasticParser} # The default JSON Parser
end
```

```ruby
class FantasticParser

  def call(body)
    "I refuse to Parse"
  end

end
```


### Making HTTP Calls

The Discourse `HTTPPort` is the main class used to send HTTP requests.  It takes a configuration for the individual call and the request is executed by calling the `call` method. The params that can be passed into the block are:

+ service
+ resource
+ request_headers
+ request_body
+ query_params
+ encoding
+ return_cache_directives
+ use_http_caching


```ruby
Discourse::HttpPort.new.get do |p|
  p.service = service
  p.resource = resource
  p.use_http_caching
end.()
```


```ruby
Discourse::HttpPort.new.post do |p|
  p.service = service
  p.resource = resource
  p.request_headers = {authorization: auth_header}
  p.request_body = credentials
  p.encoding = :url_encoded
end.()
```

The request returns a tuple (in this case a array of 2 parts), containing a stylised HTTP status as a symbol, and the result body, parsed based on the content_type (remember Discourse only supports  `text/html` and `application/json` are supported directly)

### Using Circuit Breakers


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/discourse.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
