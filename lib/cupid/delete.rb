class Cupid
  module Delete
    def delete_emails(ids)
      post :delete, server.emails(ids)
    end

    def delete_emails_like(name)
      ids = emails(name).map {|it| it[:id] }
      ids.empty? ? Response.ok : delete_emails(ids)
    end
  end
end
