class Cupid
  module Delete
    def delete_emails(ids)
      request :delete, server.emails(ids)
    end

    def delete_emails_like(name)
      # TODO: REFACTOR ME
      response = emails name
      response = [response.result] if response.result.is_a? Hash
      ids = response.map {|it| it[:id] }
      ids.empty? ? Response.empty : delete_emails(ids)
    end
  end
end
