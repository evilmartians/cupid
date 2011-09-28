module Cupid
  class Session
    # User object:
    # {
    #   :email => 'email@email.com',
    #   :lists => [list_id1, list_id2...],
    #   :first_name => 'Name',
    #   :last_name => 'Lastname'
    # }
    def create_subscriber(user, account=nil)
      soap_body = prepare_subscriber(user, account)

      response = build_request('Create', 'CreateRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      created_user_id = response.css('NewID').text
    end

    def create_subscribers(users, account=nil)
      soap_body = users.map{ |user| prepare_subscriber(user, account) }

      response = build_request('Create', 'CreateRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      created_user_id = response.css('NewID').text
    end

    private

    def prepare_subscriber(user, account=nil)
      user[:lists].map!{ |list| list_object(list) }
      account ||= @account

      create_subscriber_object(user, account)
    end

    def create_subscriber_object(user, account)
      subscriber_object =   '<Objects xsi:type="Subscriber"><ObjectID xsi:nil="true"/>'
      subscriber_object +=  '<PartnerKey xsi:nil="true" />'
      subscriber_object +=  '<Client><ID>' + account.to_s + '</ID></Client>' if account
      subscriber_object +=  user[:lists].join('') if user[:lists]
      subscriber_object +=  '<FirstName>' + user[:first_name].to_s + '</FirstName>' if user[:first_name]
      subscriber_object +=  '<LastName>' + user[:last_name].to_s + '</LastName>' if user[:last_name]
      subscriber_object +=  '<EmailAddress>' + user[:email] + '</EmailAddress>'
    end
    
    def list_object(list_id)
      '<Lists>
        <PartnerKey xsi:nil="true">
        </PartnerKey>
        <ID>' + list_id.to_s + '</ID>
        <ObjectID xsi:nil="true">
        </ObjectID>
      </Lists>'
    end

    subscriber_object += '</Objects>'
  end
end