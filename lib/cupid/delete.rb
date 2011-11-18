class Cupid
  module Delete
    def delete_emails(ids)
      post :delete, server.emails(ids)
    end
  end
end
