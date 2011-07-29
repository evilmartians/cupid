module Cupid
  class Session
    def create_subscriber(email, *args)
      options = args.extract_options!
      options[:email] = email.to_s

      soap_body = '<Objects xsi:type="Subscriber">' +
                    create_subscriber_object(options) +
                  '</Objects>'

      build_request('Create', 'CreateRequest', soap_body)
    end

    def create_subscribers(*args)
      raise NoMethodError.new "I will implement this method soon"
    end

    private
      def create_subscriber_object(options)
        subscriber_object =   '<ObjectID xsi:nil="true"/>'
        subscriber_object +=  '<PartnerKey xsi:nil="true" />'
        subscriber_object +=  '<Client><ID>' + options[:client_id].to_s + '</ID></Client>' if options[:client_id]
        subscriber_object +=  '<Lists>' + options[:lists].map(&:list_object).join('') + '</Lists>' if options[:lists]
        subscriber_object +=  '<FirstName>' + options[:first_name].to_s + '</FirstName>' if options[:first_name]
        subscriber_object +=  '<LastName>' + options[:last_name].to_s + '</LastName>' if options[:last_name]
        subscriber_object +=  '<EmailAddress>' + options[:email] + '</EmailAddress>'
      end
      
      def list_object(list_id)
        '<PartnerKey xsi:nil="true">
        </PartnerKey>
        <ID>' + list_id.to_s + '</ID>
        <ObjectID xsi:nil="true">
        </ObjectID>'
      end
  end
end