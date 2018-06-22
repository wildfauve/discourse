module Discourse

  class HttpChannel

    include Logging

    attr_accessor :status, :response_body, :http_status,
                  :resource, :service, :method, :request_headers, :query_params, :request_body,
                  :try_cache, :content_type, :encoding

    class DirectiveError < PortException ; end
    class RemoteServiceError < PortException ; end
    class MediaContentError < PortException ; end

    DEFAULT_CONTENT_TYPE = "application/json"
    DEFAULT_ENCODING     = DEFAULT_CONTENT_TYPE

    SUPPORTED_MIME_TYPE_PARSERS = {
      "text/html" => IC["html_parser"],
      "application/json" => IC["json_parser"],
      "application/xml" => IC["xml_parser"],
      "application/soap+xml" => IC["xml_parser"],
      "text/xml" => IC["xml_parser"]
    }

    def return_cache_directives
      @cache_directives = true
    end

    def use_http_caching
      @try_cache = true
    end

    def call
      raise self.class::DirectiveError if service.nil?
      to_port(service_address: port_binding, method: method)
    end


    def port_binding
      port_binding = service_discovery.new.(service: service) + (resource.to_s || "")
    end

    private

    # HTTP port
    # service_address: a URL
    def to_port(service_address: nil, method: nil)
      begin
        self.send(method, service_address)
      rescue Faraday::Error => e
        raise self.class::RemoteServiceError.new(msg: e.cause)
      end
    end


    def get(service_address)
      resp = get_service_call_function.(get_options(service_address))
      status = evalulate_status(resp.status)
      # status == :ok ? response_body = parse_body(resp) : response_body = nil
      http_response_value.new(body: parse_body(resp), status: status)
    end

    def get_options(service_address)
      options = {service_address: service_address,
                 headers: request_headers,
                 query_params: query_params
                }
      options[:cache_store] = http_cache if try_cache
      options
    end

    def get_service_call_function
      @get_service_call ||= lambda do |service_address:, headers: {}, query_params: {}, cache_store: nil|
        connection = http_connection.connection(service_address, encoding, cache_store)
        connection.get do |req|
          req.headers = {}.merge!(headers) if headers
          req.params = query_params if query_params
        end
      end
    end

    def get_through_cache(address:, otherwise:)
      http_cache_handler.(service_address: address, request: otherwise)
    end

    def post(service_address)
      debug("HTTPChannel#post => #{service_address}")
      debug("HTTPChannel#post => #{request_body}")
      connection = http_connection.connection(service_address, encoding)
      resp = connection.post do |req|
        req.body = request_body
        req.headers = request_header_builder(request_headers, content_type)
      end
      response_body = parse_body(resp)
      http_response_value.new(body: response_body, status: evalulate_status(resp.status))
    end

    def delete(service_address)
      connection = http_connection.connection(service_address, encoding)
      resp = connection.delete do |req|
        req.body = request_body
        req.headers = {}.merge!(request_headers)
      end
      response_body = parse_body(resp)
      http_response_value.new(body: response_body, status: evalulate_status(resp.status))
    end


    def respond(resp)
      http_response_value.new(
                                body: parse_body(resp.headers[:content_type], resp.body),
                                status: evalulate_status(resp.status)
                              )
    end

    def evalulate_status(http_status)
      case http_status
      when 200..300
        :ok
      when 401, 403
        :unauthorised
      when 500..530
        :system_failure
      else
        :fail
      end
    end

    def parse_body(response)
      content_type = response.headers["content-type"]
      content_type ? mime = content_type.split(";").first : mime = DEFAULT_CONTENT_TYPE
      if configuration.config.type_parsers.keys.include? mime
        configuration.config.type_parsers[mime].(response.body)
      elsif SUPPORTED_MIME_TYPE_PARSERS.keys.include? mime
        SUPPORTED_MIME_TYPE_PARSERS[mime].(response.body)
      else
        raise self.class::MediaContentError.new(retryable: false)
      end
    end

    def html_parser(body)
      body
    end

    def request_header_builder(hdrs, content_type)
      return {}.merge(content_type: content_type) unless request_headers

      request_headers.has_key?(:content_type) ? request_headers : request_headers.merge(content_type: content_type)
    end

    def configuration
      IC["configuration"]
    end

    def service_discovery
      IC["service_discovery"]
    end

    def http_response_value
      IC["http_response_value"]
    end

    def cache_directives
      IC["cache_directives"]
    end

    def http_cache_handler
      IC["http_cache_handler"]
    end

    def http_cache
      IC["http_cache"]
    end

    def http_connection
      IC["http_connection"]
    end

  end
end
