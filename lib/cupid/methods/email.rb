module Cupid
  class Session
    def retreive_email_folders(account)
      soap_body = '<RetrieveRequest>
                    <ClientIDs>
                    <ID>' + account + '</ID>
                    </ClientIDs>
                    <ObjectType>DataFolder</ObjectType>
                    <Properties>ID</Properties>
                    <Properties>Name</Properties>
                    <Properties>ParentFolder.ID</Properties>
                    <Properties>ParentFolder.Name</Properties>
                    <Filter xsi:type="SimpleFilterPart">
                      <Property>ContentType</Property>
                      <SimpleOperator>like</SimpleOperator>
                      <Value>email</Value>
                    </Filter>
                   <RetrieveRequest>'

      build_request('Retrieve', 'RetrieveRequestMsg', soap_body)
    end

    def create_email(subject, body, *args)
      options = args.extract_options!
      options[:subject] = subject.to_s
      options[:body] = CGI.escapeHTML body.to_s
      
      options[:email_type] = 'HTML'
      options[:is_html_paste] = true # ??

      soap_body = '<Objects xsi:type="Email">' +
                    create_email_object(options) +
                  '</Objects>'

      build_request('Create', 'CreateRequest', soap_body)
    end

    def create_emails(*args)
      raise NoMethodError.new "I will implement this method soon"
    end

    private
      def create_email_object(options)
        email_object =   '<ObjectID xsi:nil="true"/>'
        email_object +=  '<Client><ID>' + options[:client_id].to_s + '</ID></Client>' if options[:client_id]
        email_object +=  '<CategoryID>' + options[:category_id].to_s + '</CategoryID>' if options[:category_id]
        email_object +=  '<Name>' + options[:name].to_s + '</Name>' if options[:name]
        email_object +=  '<Description>' + options[:description].to_s + '</Description>' if options[:description]
        email_object +=  '<Subject>' + options[:subject] + '</Subject>' +
                         '<HTMLBody>' + options[:body] + '</HTMLBody>' +
                         '<EmailType>' + options[:email_type] + '</EmailType>' +
                         '<IsHTMLPaste>' + options[:is_html_paste] + '</IsHTMLPaste>'
      end
  end
end