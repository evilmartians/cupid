module Cupid
  class Session
    def retrieve_email_folders(account=nil, properties=nil)
      account ||= @account
      properties ||= ['ID', 'Name', 'ParentFolder.ID', 'ParentFolder.Name']
      filters = '<Filter xsi:type="SimpleFilterPart">' +
                  '<Property>ContentType</Property>' +
                  '<SimpleOperator>like</SimpleOperator>' +
                  '<Value>email</Value>' +
                '</Filter>'

      soap_body = build_retrieve(account.to_s, 'DataFolder', properties, filters)
      response = build_request('Retrieve', 'RetrieveRequestMsg', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      all_folders = response.css('Results').map{|f| {f.css('Name').to_a.map(&:text).join('/') => f.css('ID')[0].text}}
    end

    def retrieve_email_copies(name, account=nil, properties=nil)
      account ||= @account
      properties ||= ['ID', 'Name']
      filters = '<Filter xsi:type="SimpleFilterPart">' +
                  '<Property>Name</Property>' +
                  '<SimpleOperator>like</SimpleOperator>' +
                  '<Value>' + name + '</Value>' +
                '</Filter>'

      soap_body = build_retrieve(account.to_s, 'Email', properties, filters)
      response = build_request('Retrieve', 'RetrieveRequestMsg', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      all_copies = response.css('Results').map{|f| {f.css('Name').to_a.map(&:text).join('/') => f.css('ID')[0].text}}
    end

    def retrieve_emails_from_folder(folder, account=nil, properties=nil)
      account ||= @account
      properties ||= ['ID', 'Name']
      filters = '<Filter xsi:type="SimpleFilterPart">' +
                  '<Property>CategoryID</Property>' +
                  '<SimpleOperator>equals</SimpleOperator>' +
                  '<Value>' + folder + '</Value>' +
                '</Filter>'

      soap_body = build_retrieve(account.to_s, 'Email', properties, filters)
      response = build_request('Retrieve', 'RetrieveRequestMsg', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      all_copies = response.css('Results').map{|f| {f.css('Name').to_a.map(&:text).join('/') => f.css('ID')[0].text}}
    end

    def create_email(subject, body, *args)
      soap_body = prepare_email(subject, body, args)

      response = build_request('Create', 'CreateRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      created_email_id = response.css('NewID').text
    end

    def create_folder(title, *args)
      soap_body = prepare_folder(title, args)

      response = build_request('Create', 'CreateRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      created_folder_id = response.css('NewID').text
    end

    def send_email_to_list(email_id, list_id, account=nil)
      soap_body = prepare_send(email_id, list_id, account)

      response = build_request('Create', 'CreateRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      created_send_id = response.css('NewID').text
    end

    def create_emails(subject_bodies, *args)
      soap_body = ''
      subject_bodies.each{ |subject, body| soap_body += prepare_email(subject, body, args) }

      response = build_request('Create', 'CreateRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      response.css('Results').map{ |f| f.css('NewID').text }
    end

    def create_folders(titles, *args)
      soap_body = titles.map{ |title| prepare_folder(title, args) }.join('')

      response = build_request('Create', 'CreateRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      response.css('Results').map{ |f| f.css('NewID').text }
    end

    def send_emails_to_lists(emails_lists, account=nil)
      soap_body = ''
      emails_lists.each{ |email_id, list_id| soap_body += prepare_send(email_id, list_id, account) }

      response = build_request('Create', 'CreateRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      response.css('Results').map{ |f| f.css('NewID').text }
    end

    def delete_email(email_id, account=nil)
      soap_body = prepare_delete_email(email_id, account)

      response = build_request('Delete', 'DeleteRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      response.css('Results').css('StatusCode').text == 'OK'
    end

    def delete_emails(emails, account=nil)
      soap_body = emails.map{ |email_id| prepare_delete_email(email_id, account) }.join('')

      response = build_request('Delete', 'DeleteRequest', soap_body)
      response = Nokogiri::XML(response.http.body).remove_namespaces!
      response.css('Results').map{ |f| f.css('StatusCode').text == 'OK' }
    end

    private

    def prepare_email(subject, body, args)
      options = args.extract_options!
      options[:subject] = CGI.escapeHTML subject.to_s
      options[:body] = CGI.escapeHTML body.to_s
      options[:client_id] ||= @account

      options[:email_type] ||= 'HTML'
      options[:is_html_paste] ||= 'true' # ??
      options[:character_set] ||= 'utf-8'

      create_email_object(options)
    end

    def create_email_object(options)
      email_object =   '<Objects xsi:type="Email"><ObjectID xsi:nil="true"/>'
      email_object +=  '<Client><ID>' + options[:client_id].to_s + '</ID></Client>' if options[:client_id]
      email_object +=  '<CategoryID>' + options[:category_id].to_s + '</CategoryID>' if options[:category_id]
      email_object +=  '<Name>' + options[:name].to_s + '</Name>' if options[:name]
      email_object +=  '<Description>' + options[:description].to_s + '</Description>' if options[:description]
      email_object +=  '<Subject>' + options[:subject] + '</Subject>' +
                       '<HTMLBody>' + options[:body] + '</HTMLBody>' +
                       '<EmailType>' + options[:email_type] + '</EmailType>' +
                       '<IsHTMLPaste>' + options[:is_html_paste] + '</IsHTMLPaste>' +
                       '<CharacterSet>' + options[:character_set] + '</CharacterSet></Objects>'
    end

    def prepare_folder(title, args)
      options = args.extract_options!
      options[:title] = CGI.escapeHTML title.to_s
      options[:description] ||= 'description'
      options[:client_id] ||= @account

      options[:content_type] ||= 'email'
      options[:is_active] ||= 'true'
      options[:is_editable] ||= 'true'
      options[:allow_children] ||= 'true'

      create_folder_object(options)
    end

    def create_folder_object(options)
      folder_object =   '<Objects xsi:type="DataFolder"><ObjectID xsi:nil="true"/>'
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
      folder_object += '</Objects>'
    end

    def prepare_send(email_id, list_id, account=nil)
      account ||= @account
      create_send_object(email_id, list_id, account)
    end

    def create_send_object(email_id, list_id, account)
      '<Objects xsi:type="Send"><PartnerKey xsi:nil="true"/>' +
       '<ObjectID xsi:nil="true"/>' +
       '<Client><ID>' + account.to_s + '</ID></Client>' +
       '<Email>' +
         '<PartnerKey xsi:nil="true"/>' +
         '<ID>' + email_id.to_s + '</ID>' +
         '<ObjectID xsi:nil="true"/>' +
       '</Email>' +
       '<List>' +
         '<PartnerKey xsi:nil="true"/>' +
         '<ObjectID xsi:nil="true"/>' +
         '<ID>' + list_id.to_s + '</ID>' +
       '</List>' +
      '</Objects>'
    end

    def prepare_delete_email(email_id, account=nil)
      account ||= @account
      create_delete_email_object(email_id, account)
    end

    def create_delete_email_object(email_id, account)
      '<Objects xsi:type="Email">' +
        '<Client>' +
          '<ID>' + account.to_s + '</ID>' +
        '</Client>' +
        '<ID>' + email_id.to_s + '</ID>' +
        '<ObjectID xsi:nil="true"/>' +
      '</Objects>'
    end
  end
end