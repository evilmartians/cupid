require 'cupid/methods'

module Cupid
  class Session
    DEFAULTS = {
      :soap_s4_url          => "https://webservice.s4.exacttarget.com/etframework.wsdl",
      :wsa_soap_s4_to       => "https://webservice.s4.exacttarget.com/Service.asmx",
      :use_ssl              => true
    }

    def initialize(options={})
      @username   = options[:username]    ||= Cupid.username
      @password   = options[:password]    ||= Cupid.password
      @account    = options[:account]     ||= Cupid.account
      @headers    = {"Content-Type" => "application/x-www-form-urlencoded", "Connection" => "close"}

      @api_uri = @api_wsdl = DEFAULTS[:soap_s4_url]
      @api_uri = URI.parse(@api_uri)
      @api_url = Net::HTTP.new(@api_uri.host, @api_uri.port)

      @api_url.use_ssl = DEFAULTS[:use_ssl]
      @wsa_soap_s4_to = DEFAULTS[:wsa_soap_s4_to]
    end

    private

    def build_request(type, method, body)
      client = Savon::Client.new(@api_wsdl)
      client.wsse.username = @username
      client.wsse.password = @password
      client.wsse.created_at = Time.now.utc
      client.wsse.expires_at = (Time.now + 120).utc

      header = {
        'a:Action' => type,
        'a:MessageID' => 'urn:uuid:99e6822c-5436-4fec-a243-3126c14924f6',
        'a:ReplyTo' => {
            'a:Address' => 'http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous'
          },
        'VsDebuggerCausalityData' => 'uIDPo5GdUXRQCEBNrqnw0gOEloMAAAAAIAi4IHpPlUiMs1MZ2raBIhJnF/jqJLlAgZIny03R+tgACQAA',
        'a:To' => @wsa_soap_s4_to
      }

      namespaces = {
        'xmlns:s'=>"http://schemas.xmlsoap.org/soap/envelope/",
        'xmlns:a'=>"http://schemas.xmlsoap.org/ws/2004/08/addressing",
        'xmlns:u'=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
        'xmlns:xsi'=>"http://www.w3.org/2001/XMLSchema-instance",
        'xmlns:xsd'=>"http://www.w3.org/2001/XMLSchema",
        'xmlns:o'=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
      }

      response = client.request type.downcase.to_sym do |soap|
        soap.input = [method, { 'xmlns'=>"http://exacttarget.com/wsdl/partnerAPI"}]
        soap.header = header
        soap.env_namespace = :s
        soap.namespaces = namespaces
        soap.body = body
      end
    end

    def build_retrieve(id, object_type, properties, filters=nil)
      body = '<RetrieveRequest>' +
                '<ClientIDs>' +
                  '<ID>' + id.to_s + '</ID>' +
                '</ClientIDs>' +
                '<ObjectType>' + object_type.to_s + '</ObjectType>' 
      properties.each do |p|
        body += '<Properties>' + p.to_s + '</Properties>'
      end

      body += filters if filters

      body + '</RetrieveRequest>'
    end
  end
end
