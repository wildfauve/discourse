# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'discourse/version'

Gem::Specification.new do |spec|
  spec.name          = "discourse"
  spec.version       = Discourse::VERSION
  spec.authors       = ["Col Perks"]
  spec.email         = ["wild.fauve@gmail.com"]

  spec.summary       = %q{Provides an HTTP client wapper with circuitbreakers and caching}
  spec.description   = %q{Longer Description}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'dry-struct'
  spec.add_dependency 'dry-types'
  spec.add_dependency 'stoplight'
  spec.add_dependency 'mini_cache'
  spec.add_dependency 'diplomat'
  spec.add_dependency 'ytry'
  spec.add_dependency 'typhoeus'
  spec.add_dependency 'faraday-http-cache'
  spec.add_dependency 'ruby-kafka'
  spec.add_dependency 'zk'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
