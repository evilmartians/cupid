class Cupid
  module Update
    def ui_set_email(ui, email)
      resource :update, ui_data(ui, email)
    end

    def update_user_attributes(key, properties)
      resource :update, server.object("Subscriber", {
        :customer_key => key,
        :attributes => properties.collect{ |k, v| {name: k, value: v} }
      })
    end

    def describe_user
      resource :describe, {
        :describe_requests => {
          :client => { 'ID' => server.account },
          :object_definition_request => {
            :object_type => "Subscriber"
          }
        }
      }
    end

    private

    def ui_data(ui, email)
      server.object 'EmailSendDefinition',
        :customer_key => ui.customer_key,
        :email => { 'ID' => email }
    end
  end
end
