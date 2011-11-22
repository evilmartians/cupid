class Cupid
  module Retrieve
    LIST_FIELDS     = %w(ID ListName CustomerKey)
    EMAIL_FIELDS    = %w(ID Name)
    FOLDER_FIELDS   = %w(ID Name ParentFolder.ID ParentFolder.Name)
    DELIVERY_FIELDS = %w(ID Status)

    def emails(name=nil, fields=EMAIL_FIELDS)
      retrieve 'Email', fields, filter_email_like(name)
    end

    def folders(fields=FOLDER_FIELDS)
      retrieve 'DataFolder', fields, filter_folders
    end

    def lists(fields=LIST_FIELDS)
      retrieve 'List', fields
    end

    def deliveries(fields=DELIVERY_FIELDS)
      retrieve 'Send', fields
    end

    private

    def retrieve(type, fields, options={})
      post :retrieve, :retrieve_request => {
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
