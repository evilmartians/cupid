class Cupid
  module Retrieve
    LIST_FIELDS     = %w(ID ListName CustomerKey)
    EMAIL_FIELDS    = %w(ID Name)
    FOLDER_FIELDS   = %w(ID Name ParentFolder.ID ParentFolder.Name)
    DELIVERY_FIELDS = %w(ID Status)

    def emails(name=nil, *fields)
      retrieve 'Email', EMAIL_FIELDS + fields, filter_email_like(name)
    end

    def folders(*fields)
      retrieve 'DataFolder', FOLDER_FIELDS + fields, filter_folders
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

    def filter_folders
      server.filter 'ContentType', 'like', 'email'
    end

    def filter_email_like(name)
      server.filter 'Name', 'like', name
    end
  end
end
