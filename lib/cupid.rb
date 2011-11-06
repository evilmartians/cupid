require 'savon'
require 'cupid/version'

class Cupid
  ET_NAMESPACE = 'http://exacttarget.com/wsdl/partnerAPI'
  ET_ENDPOINT  = 'https://webservice.s4.exacttarget.com/Service.asmx'

  attr_reader :client, :account

  def initialize(username, password, account)
    @client  = get_client username, password
    @account = account
  end

  private

  def get_client(username, password)
    Savon::Client.new.tap do |client|
      client.wsdl.namespace = ET_NAMESPACE
      client.wsdl.endpoint  = ET_ENDPOINT
      client.wsse.credentials username, password
    end
  end
end
