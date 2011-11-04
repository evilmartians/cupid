require 'savon'
require 'cupid/version'

class Cupid
  attr_reader :client, :account
  WSDL = 'https://webservice.s4.exacttarget.com/etframework.wsdl'

  def initialize(username, password, account)
    @client  = get_client username, password
    @account = account
  end

  private

  def get_client(username, password)
    Savon::Client.new(WSDL).tap do |client|
      client.wsse.credentials username, password
      client.wsse.timestamp = true
    end
  end
end
