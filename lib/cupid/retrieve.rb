class Cupid
  module Retrieve

    extend Guard

    def emails_by_name(pattern)
      retrieve(:Email) { name =~ pattern }
    end
    protect_with_guard :emails_by_name, Guard::String


    def emails_by_id(*ids)
      return [] unless ids.any?
      retrieve(:Email) { id =~ ids }
    end
    protect_with_guard :emails_by_id, Guard::Rest[Guard::Integer]


    def email_by_id(id)
      retrieve_first(:Email) { |email| email.id == id }
    end
    protect_with_guard :email_by_id, Guard::Integer


    def send_object_by_id(id)
      retrieve_first(:Send) { |s| s.id == id }
    end
    protect_with_guard :send_object_by_id, Guard::Integer


    def send_objects_by_email_id(id)
      retrieve(:Send) { email_id == id }
    end
    protect_with_guard :send_object_by_id, Guard::Integer


    def ui_emails(id)
      retrieve(:EmailSendDefinition) { category_id == id }
    end
    protect_with_guard :ui_emails, Guard::Integer


    def lists
      retrieve :List
    end


    def folders
      data_folders :email
    end


    def ui_folders
      data_folders :userinitiated
    end


    def retrieve(type, &filter)
      model_cls = Models::module_eval(type.to_s)
      options = {}
      puts "filter = #{filter}"
      options = model_cls.class_eval &filter unless filter.nil?
      items = resources :retrieve, :retrieve_request => {
        :object_type => type,
        :properties => model_cls::properties,
        "ClientIDs" => {
          "ID" => server.account
        }
      }.merge(options)
      items.collect{ |item| model_cls.new item }
    end
    protect_with_guard :retrieve, Guard::Symbol, Guard::Proc

    def retrieve_first(type, &filter)
      retrieve(type, &filter).first
    end
    protect_with_guard :retrieve_first, Guard::Symbol, Guard::Proc

    protected

    def data_folders(type)
      retrieve(:DataFolder) { content_type =~ type.to_s }
    end

  end
end
