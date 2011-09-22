module Cupid
  class Session
    def retrieve_lists(account, properties=nil)
      properties ||= ['ID', 'CustomerKey']
      
      soap_body = build_retrieve(account.to_s, 'List', properties)
      response = build_request('Retrieve', 'RetrieveRequestMsg', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      all_lists = response.css('Results').map{|f| {f.css('CustomerKey').to_a.map(&:text).join('/') => f.css('ID')[0].text}}
    end
  end
end