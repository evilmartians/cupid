require 'savon'
Dir[File.expand_path '../cupid/*.rb', __FILE__].each &method(:require)

class Cupid
  NAMESPACE = 'http://exacttarget.com/wsdl/partnerAPI'
  ENDPOINT  = 'https://webservice.s4.exacttarget.com/Service.asmx'

  include Filter, Retrieve

  attr_reader :client, :account

  def initialize(username, password, account)
    @client  = client_with username, password
    @account = account
  end

  def request(action, options={}, &block)
    client.request(action, options) {
      soap.input = Input.for action
      client.send :process, &block if block
    }.body
  end

  def post(action, xml)
    request(action) { soap.body = xml }
  end

  private

  def client_with(username, password)
    Savon::Client.new.tap do |client|
      client.wsdl.namespace = NAMESPACE
      client.wsdl.endpoint  = ENDPOINT
      client.wsse.credentials username, password
    end
  end
end

# ExactTarget follows camelcase convention for soap objects
Gyoku.convert_symbols_to :camelcase
