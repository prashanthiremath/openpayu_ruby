# -*- encoding : utf-8 -*-
require 'net/http'
require 'uri'

module OpenPayU

  class Connection

    def self.post(endpoint, data)
      #http, uri = build_url
      Rails.logger.info "DATA #{data}"
      data_p = data
     # Rails.logger.info "http #{http.inspect}"
      #Rails.logger.info "uri #{uri.path}"
     # Rails.logger.info "Data #{data}"
      # conn = Faraday.new(:url => 'https://test.payu.in') do |faraday|
      #        faraday.request  :url_encoded
      #        faraday.response :logger, ::Logger.new(STDOUT), bodies: true 
      #        faraday.adapter  Faraday.default_adapter           
      #  end
      #request = Net::HTTP::Post.new(uri.path)
      #request = authenticate(request)
     # request.body = data
      #request['Content-Type'] =
       # "application/#{OpenPayU::Configuration.data_format}"
      #response = http.request(request)
      #Rails.logger.info "CONN #{conn}"
      #response = conn.post '/_payment', data
     #  response = conn.post '/_payment', data
      uri = URI('https://test.payu.in/_payment')
      Rails.logger.info "HERE "
      response = Net::HTTP.post_form(uri, eval(data_p))
      Rails.logger.info "Repsonse #{response['location']}"
      redirect_to response['location']
      #Rails.logger.info "RESPONSE CODE #{response.status}"
      { response: response, request: '' }
    end

    def self.put(endpoint, data)
      http, uri = build_url(endpoint)
      request = Net::HTTP::Put.new(uri.path)
      request = authenticate(request)
      request.body = data
      request['Content-Type'] =
        "application/#{OpenPayU::Configuration.data_format}"
      response = http.request(request)
      { response: response, request: request }
    end

    def self.get(endpoint, data)
      common_connection(endpoint, data, 'GET')
    end

    def self.delete(endpoint, data)
      common_connection(endpoint, data, 'DELETE')
    end

    private

    def self.authenticate(request)
      request.basic_auth(
        OpenPayU::Configuration.merchant_pos_id,
        OpenPayU::Configuration.signature_key
      )
      request
    end

    def self.build_url
      uri = URI.parse(Configuration.get_base_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if OpenPayU::Configuration.use_ssl?
      [http, uri]
    end

    def self.common_connection(endpoint, data, method)
      http, uri = build_url(endpoint)
      request =
        if method == 'DELETE'
          Net::HTTP::Delete.new(uri.request_uri)
        else
          Net::HTTP::Get.new(uri.request_uri)
        end
      request = authenticate(request)
      request['Content-Type'] =
        "application/#{OpenPayU::Configuration.data_format}"
      response = http.request(request)
      { response: response, request: request }
    end

  end

end
