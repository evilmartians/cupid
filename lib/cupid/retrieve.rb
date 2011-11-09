class Cupid
  module Retrieve
    EMAIL_FOLDER_FIELDS = %w(ID Name ParentFolder.ID ParentFolder.Name)

    def retrieve(type, fields, options={})
      post :retrieve, :retrieve_request => {
        :object_type => type,
        :properties => fields
      }.merge(options)
    end

    def retrieve_email_folders(fields=EMAIL_FOLDER_FIELDS)
      retrieve 'DataFolder', fields, email_folder_filter
    end

    private

    def email_folder_filter
      filter 'ContentType', 'like', 'email'
    end
  end
end
