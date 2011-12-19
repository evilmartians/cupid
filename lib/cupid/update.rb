class Cupid
  module Update
    def ui_set_email(ui, email)
      resource :update, ui_data(ui, email)
    end

    private

    def ui_data(ui, email)
      server.object 'EmailSendDefinition',
        :customer_key => ui.customer_key,
        :email => { 'ID' => email }
    end
  end
end
