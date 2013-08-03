class Cupid
  module Models
    class Email < Base

      map_fields :id   => "ID",
                 :name => "Name"

      convert(:id) { |id| id.to_i }

      has_many(:Send) { |email, send| send.email_id == email.id }
      has_many(:EmailSendDefinition) { |email, send_def| send_def.email_id == email.id }

    end
  end
end
