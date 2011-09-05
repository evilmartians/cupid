module Cupid
  class Session
    def retrieve_email_folders(account)
      soap_body = '<RetrieveRequest>
                    <ClientIDs>
                    <ID>' + account.to_s + '</ID>
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
                   </RetrieveRequest>'

      response = build_request('Retrieve', 'RetrieveRequestMsg', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      all_folders = response.css('Results').map{|f| {f.css('Name').to_a.map(&:text).join('/') => f.css('ID')[0].text}}
    end

    def create_email(subject, body, *args)
      options = args.extract_options!
      options[:subject] = CGI.escapeHTML subject.to_s
      options[:body] = CGI.escapeHTML body.to_s
      
      options[:email_type] = 'HTML'
      options[:is_html_paste] = 'true' # ??

      soap_body = '<Objects xsi:type="Email">' +
                    create_email_object(options) +
                  '</Objects>'

      response = build_request('Create', 'CreateRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      created_email_id = response.css('NewID').text
    end

    def create_folder(title, *args)
      options = args.extract_options!
      options[:title] = CGI.escapeHTML title.to_s
      options[:description] ||= 'description'

      options[:content_type] ||= 'email'
      options[:is_active] ||= 'true'
      options[:is_editable] ||= 'true'
      options[:allow_children] ||= 'true'

      soap_body = '<Objects xsi:type="DataFolder">' +
                    create_folder_object(options) +
                  '</Objects>'

      response = build_request('Create', 'CreateRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      created_folder_id = response.css('NewID').text
    end

    def email_link(email_id)
      "https://members.s4.exacttarget.com/Content/Email/EmailEdit.aspx?eid=" + email_id.to_s
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

    def create_folder_object(options)
      folder_object =   '<ObjectID xsi:nil="true"/>'
      folder_object +=  '<Client><ID>' + options[:client_id].to_s + '</ID></Client>' if options[:client_id]
      folder_object +=  '<CustomerKey>' + options[:title].to_s + '</CustomerKey>' if options[:title]
      folder_object +=  '<Name>' + options[:title].to_s + '</Name>' +
                        '<Description>' + options[:description].to_s + '</Description>' +
                        '<ContentType>' + options[:content_type].to_s + '</ContentType>' +
                        '<IsActive>' + options[:is_active].to_s + '</IsActive>' +
                        '<IsEditable>' + options[:is_editable].to_s + '</IsEditable>' +
                        '<AllowChildren>' + options[:allow_children].to_s + '</AllowChildren>'

      if options[:parent]
        folder_object +=  '<ParentFolder>
                              <PartnerKey xsi:nil="true"/>
                              <ModifiedDate xsi:nil="true"/>
                              <ID>' + options[:parent].to_s + '</ID>
                              <ObjectID xsi:nil="true"/>
                           </ParentFolder>'
      end
    end
  end
end