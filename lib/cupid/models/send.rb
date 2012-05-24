class Cupid
  module Models
    class Send < Base

      map_fields :id =>       "ID",
                 :status =>   "Status",
                 :email_id => "Email.ID",
                 :send_at =>  "SendDate",
                 :sent_at =>  "SentDate"

      convert(:id) { |id| id.to_i }
      convert(:email_id) { |email_id| email_id.to_i }
      convert(:status) { |status| status.downcase.to_sym }

    end
  end
end
