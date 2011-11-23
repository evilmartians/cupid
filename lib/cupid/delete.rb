class Cupid
  module Delete
    def delete_emails(*objects)
      request :delete, server.emails(objects)
    end

    def delete_emails_like(name)
      objects = emails(name)
      objects.empty? ? [] : delete_emails(*objects)
    end
  end
end
