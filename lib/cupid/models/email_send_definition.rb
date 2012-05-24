class Cupid
  module Models
    class EmailSendDefinition < Base

      map_fields :email_id      => "Email.ID",
                 :customer_key  => "CustomerKey",
                 :name          => "Name",
                 :email_subject => "EmailSubject",
                 :category_id   => "CategoryID"

      convert(:category_id) { |category_id| category_id.to_i }
      convert(:email_id) { |email_id| email_id.to_i }

    end
  end
end
