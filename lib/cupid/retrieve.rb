class Cupid
  module Retrieve

    extend Typesig

    def emails_by_name(pattern)
      retrieve(:Email) { name =~ pattern }
    end
    typesig :emails_by_name, String


    def emails_by_id(*ids)
      return [] unless ids.any?
      retrieve(:Email) { id =~ ids }
    end
    typesig :emails_by_id, :rest, Fixnum


    def email_by_id(id)
      retrieve_first(:Email) { |email| email.id == id }
    end
    typesig :email_by_id, Fixnum


    def send_object_by_id(id)
      retrieve_first(:Send) { |s| s.id == id }
    end
    typesig :send_object_by_id, Fixnum


    def send_objects_by_email_id(id)
      retrieve(:Send) { email_id == id }
    end
    typesig :send_objects_by_email_id, Fixnum


    def ui_emails(id)
      retrieve(:EmailSendDefinition) { category_id == id }
    end
    typesig :ui_emails, Fixnum


    def lists
      retrieve :List
    end


    def folders
      retrieve(:DataFolder) { content_type =~ "email" }
    end


    def ui_folders
      retrieve(:DataFolder) { content_type =~ "userinitiated" }
    end


    def retrieve(type, &filter)
      model_cls = Models::module_eval(type.to_s)
      options = {}
      options = model_cls.class_eval &filter unless filter.nil?
      items = resources :retrieve, :retrieve_request => {
        :object_type => type,
        :properties => model_cls::properties,
        "ClientIDs" => {
          "ID" => server.account
        }
      }.merge(options)
      Models::Set.new self, type, items.collect{ |item| model_cls.new(self, item) }
    end
    typesig :retrieve, Symbol


    def retrieve_first(type, &filter)
      retrieve(type, &filter).first
    end
    typesig :retrieve_first, Symbol

  end
end
