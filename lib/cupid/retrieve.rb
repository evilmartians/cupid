class Cupid
  module Retrieve
    LIST_FIELDS     = %w(ID ListName CustomerKey)
    EMAIL_FIELDS    = %w(ID Name)
    FOLDER_FIELDS   = %w(ID Name ParentFolder.ID ParentFolder.Name)
    DELIVERY_FIELDS = %w(ID Status)
    UI_EMAIL_FIELDS = %w(CustomerKey Name Email.ID EmailSubject CategoryID)

    def emails(name=nil, *fields)
      retrieve 'Email',
        EMAIL_FIELDS + fields,
        filter_email_like(name)
    end

    def ui_emails(folder=nil, *fields)
      retrieve 'EmailSendDefinition',
        UI_EMAIL_FIELDS + fields,
        filter_by_folder(folder)
    end

    def folders(*fields)
      data_folders 'email', *fields
    end

    def ui_folders(*fields)
      data_folders 'userinitiated', *fields
    end

    def lists(*fields)
      retrieve 'List', LIST_FIELDS + fields
    end

    def deliveries(*fields)
      retrieve 'Send', DELIVERY_FIELDS + fields
    end

    private

    def retrieve(type, fields, options={})
      resources :retrieve, :retrieve_request => {
        :object_type => type,
        :properties => fields,
        'ClientIDs' => { 'ID' => server.account }
      }.merge(options)
    end

    def data_folders(type, *fields)
      retrieve 'DataFolder', FOLDER_FIELDS + fields, filter_folders(type)
    end

    def filter_folders(type)
      server.filter 'ContentType', 'like', type
    end

    def filter_email_like(name)
      server.filter 'Name', 'like', name
    end

    def filter_by_folder(id)
      server.filter 'CategoryID', 'equals', id
    end
  end
end
