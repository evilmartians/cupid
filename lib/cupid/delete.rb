class Cupid
  module Delete
    # TODO: refactor
    def delete_folders(*objects)
      resources :delete, server.folders(objects)
    end

    def delete_emails(*objects)
      resources :delete, server.emails(objects)
    end

    def delete_emails_like(name)
      objects = emails(name)
      objects.empty? ? [] : delete_emails(*objects)
    end
  end
end
