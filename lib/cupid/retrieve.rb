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
      unless filter.nil?
        options = model_cls.class_eval(&filter).to_hash
        return cast_items(type, []) if options.nil?
      end
      items = resources :retrieve, retrieve_request_for(type, options)
      cast_items type, items
    end
    typesig :retrieve, Symbol


    def chunked_retrieve(type, properties, filter)
      raise "chunked_retrieve requires a block" unless block_given?
      properties = nil if properties.empty?
      model_cls = Models::module_eval(type.to_s)
      options = {}
      unless filter.nil?
        options = model_cls.class_eval(&filter).to_hash
        return if options.nil?
      end
      resp = resources :retrieve, retrieve_request_for(type, options, properties), true, false
      yield cast_items(type, resp.results)
      while resp.has_more?
        resp = resources :retrieve, continue_request_for(resp), true, false
        yield cast_items(type, resp.results)
      end
    end
    typesig :chunked_retrieve, Symbol, Array, Proc


    def retrieve_first(type, &filter)
      retrieve(type, &filter).first
    end
    typesig :retrieve_first, Symbol


    private

    def model_class_for_type(type)
      Models::module_eval(type.to_s)
    end

    def retrieve_request_for(type, options, property_names=nil)
      model_cls = model_class_for_type type
      {
        :retrieve_request => {
          :object_type => type,
          :properties => model_cls::properties(property_names),
          "ClientIDs" => {
            "ID" => server.account
          }
        }.merge(options)
      }
    end

    def continue_request_for(response)
      {
        :retrieve_request => {
          :continue_request => response.request_id
        }
      }
    end

    def cast_items(type, items)
      model_cls = model_class_for_type type
      set_cls = Models::module_eval("#{type}Set") rescue Models::Set
      set_cls.new self, type, items.collect{ |item| model_cls.new(self, item) }
    end


  end
end
