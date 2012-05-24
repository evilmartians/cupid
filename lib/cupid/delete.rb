class Cupid
  module Delete
    def delete_folders(*objects)
      resources :delete, server.folders(objects)
    end

    def delete_emails(*objects)
      resources :delete, server.emails(objects)
    end

    def delete_emails_like(name)
      objects = emails name
      objects.empty? ? [] : delete_emails(*objects)
    end

    def delete_send(id)
      resources :delete, server.send_objects([id])
    end
  end
end
