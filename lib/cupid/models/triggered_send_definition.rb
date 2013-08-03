class Cupid
  module Models
    class TriggeredSendDefinition < Base

      map_fields :name     => "Name",
                 :key      => "CustomerKey",
                 :email_id => "Email.ID",
                 :list_id  => "List.ID"

      convert(:email_id){ |email_id| email_id.to_i }
      convert(:list_id){ |list_id| list_id.to_i }

      belongs_to(:Email){ |send_def, email| email.id == send_def.email_id }
      belongs_to(:List){ |send_def, list| list.id == send_def.list_id }

    end
  end
end
