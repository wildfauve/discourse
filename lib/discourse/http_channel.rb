module Discourse

  class HttpChannel

    attr_accessor :status, :response_body, :http_status,
                  :resource, :service, :method, :req_headers, :query_params, :request_body,
                  :try_cache, :encoding

    class RemoteServiceError < PortException ; end
    class MediaContentError < PortException ; end


    SUPPORTED_MIME_TYPE_PARSERS = {
      "text/html" => :html_parser,
      "application/json" => :json_parser
    }

    def return_cache_directives
      @cache_directives = true
    end

    def use_http_caching
      @try_cache = true
    end

    def call
      port_binding = service_discovery.new.find(service: service) + resource
      to_port(service_address: port_binding, method: method)
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
      service_call = get_service_call_as_proc
      resp = if try_cache
        get_through_cache(address: service_address, otherwise: service_call)
      else
        service_call.(service_address: service_address, headers: req_headers, query_params: query_params)
      end
      response_body = parse_body(resp)
      http_response_value.new(body: response_body, status: evalulate_status(resp.status))
    end

    def get_service_call_as_proc
      service_call = lambda do |service_address:, headers: {}, query_params: {}|
        connection = http_connection.connection(service_address, encoding)
        connection.get do |req|
          req.headers = {}.merge!(headers) if headers
          req.param = query_params if query_params
        end
      end

    end

    def get_through_cache(address:, otherwise:)
      http_cache.(service_address: address, request: otherwise)
    end

    def post(service_address)
      connection = http_connection.connection(service_address, encoding)
      resp = connection.post do |req|
        req.body = request_body
        req.headers = {}.merge!(req_headers)
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

    # def connection(address)
    #   connection = Faraday.new(:url => address) do |faraday|
    #     faraday.request  encoding
    #     faraday.response :logger
    #     faraday.adapter  Faraday.default_adapter
    #   end
    #   connection
    # end

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
      content_type ? mime = content_type.split(";").first : mime = "application/json"
      if SUPPORTED_MIME_TYPE_PARSERS.keys.include? mime
        self.send(SUPPORTED_MIME_TYPE_PARSERS[mime], response.body)
      else
        raise self.class::MediaContentError.new(retryable: false)
      end
    end

    def html_parser(body)
      body
    end

    def json_parser(body)
      JSON.parse(body)
    end

    def service_discovery
      Container["service_discovery"]
    end

    def http_response_value
      Container["http_response_value"]
    end

    def cache_directives
      Container["cache_directives"]
    end

    def http_cache
      Container["http_cache"]
    end

    def http_connection
      Container["http_connection"]
    end


  end

end
