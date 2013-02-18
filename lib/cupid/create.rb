class Cupid
  module Create
    def create(type, data)
      resource :create, server.object(type, data)
    end

    def create_folder(title, parent, options={})
      create 'DataFolder', folder(title, parent, options)
    end

    def create_email(title, body, options={})
      create 'Email', email(title, body, options)
    end

    def create_delivery(email, list)
      create 'Send', delivery(email, list)
    end

    def create_list(name, folder_id)
      raise ArgumentError unless name
      response = create "List", :list_name => name, :category => folder_id
      list_id = response.data[:id].to_i
      retrieve_first(:List){ id == list_id }
    end

    def create_path(*folder_names)
      create_folder_path "email", folder_names
    end

    def create_list_path(*folder_names)
      create_folder_path "list", folder_names
    end

    def create_import_definition(name, list_id, source_key, filename)
      response = create "ImportDefinition", import_definition(name, list_id, source_key, filename)
      retrieve_first(:ImportDefinition, name: name)
    end

    def create_send_definition(params)
      email = params[:email_id]
      list = params[:list_id]
      send_classification = params[:send_classification_key]
      sender_profile = params[:sender_profile_key]
      customer_key = params[:customer_key]
      response = create "EmailSendDefinition", send_definition(customer_key, email, list, send_classification, sender_profile)
      retrieve_first :EmailSendDefinition, name: response.data[:name]
    end

    def create_triggered_send(user_key, email_address, definition_key, attributes)
      create "TriggeredSend", triggered_send(user_key, email_address, definition_key, attributes)
    end

    def create_de_object(de_key, properties)
      create "DataExtensionObject", data_extension_object(de_key, properties)
    end

    private

    def data_extension_object(de_key, properties)
      {
        partner_key: nil,
        object_id: nil,
        customer_key: de_key,
        properties: {
          property: properties.collect{ |k, v| {name: k, value: v}}
        }
      }
    end

    def triggered_send(user_key, email_address, definition_key, attributes)
      {
        triggered_send_definition: {
          customer_key: definition_key
        },
        subscribers: {
          subscriber_key: user_key,
          email_address: email_address,
          attributes: attributes.collect{ |k, v| {name: k, value: v}}
        }
      }
    end

    def create_folder_path(content_type, folder_names)
      all_folders = retrieve(:DataFolder){ |f| f.content_type =~ content_type }
      children = all_folders.reject &:parent_id
      folder_names.inject(nil) do |parent, name|
        folder = children.find{ |f| f.name == name }
        if folder
          children = all_folders.select{ |f| f.parent_id == folder.id }
        else
          children = []
        end
        if parent
          parent_id = parent.id
        else
          parent_id = nil
        end
        if folder
          folder
        else
          resp = create_folder name, parent_id, content_type: content_type
          retrieve_first :DataFolder, id: resp.id.to_i
        end
      end
    end

    def folder(title, parent, options)
      raise ArgumentError unless title and parent and options

      {
        :name           => title,
        :content_type   => :email,
        :description    => nil,
        :is_active      => true,
        :is_editable    => true,
        :allow_children => true,
        :parent_folder  => {
          'ID' => parent
        }
      }.merge options
    end

    def email(title, body, options)
      raise ArgumentError unless title and body and options

      {
        :email_type    => 'HTML',
        :character_set => 'utf-8',
        :subject       => title,
        'HTMLBody'     => body,
        'IsHTMLPaste'  => true
      }.merge options
    end

    def delivery(email, list)
      raise ArgumentError unless email and list

      {
        :email => { 'ID' => email },
        :list  => { 'ID' => list }
      }
    end

    def send_definition(customer_key, email, list, send_classification, sender_profile)
      raise ArgumentError unless customer_key and email and list and send_classification and sender_profile
      raise ArgumentError if customer_key.length > 64
      {
        name: customer_key,
        customer_key: customer_key,
        is_multipart: true,
        send_classification: { customer_key: send_classification },
        email: { id: email },
        sender_profile: { customer_key: sender_profile },
        send_definition_list: [
          {
            data_source_type_id: "List",
            send_definition_list_type: "SourceList",
            list: { id: list }
          }
        ]
      }
    end

    def import_definition(name, list_id, source_key, filename)
      raise ArgumentError unless name and list_id and source_key and filename
      {
        :name => name,
        :retrieve_file_transfer_location => {
          :customer_key => source_key
        },
        :destination_object => {
          :ID => list_id
        },
        :field_mapping_type => "InferFromColumnHeadings",
        :allow_errors => true,
        :file_spec => filename,
        :file_type => "CSV",
        :update_type => "AddAndDoNotUpdate",
        :attributes! => {
          :destination_object => { "xsi:type" => "List" }
        }
      }
    end

  end
end
