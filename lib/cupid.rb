require 'savon'
require File.expand_path "../cupid/typesig.rb", __FILE__
require File.expand_path "../cupid/models/base.rb", __FILE__
require File.expand_path "../cupid/models/set.rb", __FILE__
Dir[File.expand_path '../cupid/**/*.rb', __FILE__].each {|it| require it }

class Cupid
  NAMESPACE = 'http://exacttarget.com/wsdl/partnerAPI'
  ENDPOINT  = 'https://webservice.s4.exacttarget.com/Service.asmx'

  include Create, Update, Retrieve , Schedule, Describe

  attr_reader :client, :server

  def initialize(username, password, account)
    @client = client_with username, password
    @server = Server.new account
  end

  def resources(action, xml, check=true, return_results=true)
    Response.parse raw_request(action, xml).body, check, return_results
  end

  def resource(action, xml, check=true)
    resources(action, xml, check).first
  end

  private

  def raw_request(action, xml)
    client.request action do
      soap.input = server.input action
      soap.body  = xml
    end
  end

  def client_with(username, password)
    Savon::Client.new.tap do |client|
      client.wsdl.namespace = NAMESPACE
      client.wsdl.endpoint  = ENDPOINT
      client.wsse.credentials username, password
    end
  end
end
