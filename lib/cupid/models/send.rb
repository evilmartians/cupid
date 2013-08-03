class Cupid
  module Models
    class Send < Base

      map_fields :id =>       "ID",
                 :status =>   "Status",
                 :email_id => "Email.ID",
                 :send_at =>  "SendDate",
                 :sent_at =>  "SentDate",
                 :from_name => "FromName",
                 :from_address => "FromAddress",
                 :subject => "Subject",
                 :send_def_key => "EmailSendDefinition.CustomerKey"

      convert :id, &:to_i
      convert :email_id, &:to_i
      convert :subject, &:strip
      convert(:status) { |status| status.downcase.to_sym }

      belongs_to(:Email) { |send, email| email.id == send.email_id }
      belongs_to(:EmailSendDefinition){ |send, send_def| send_def.customer_key == send.send_def_key }
  
    end
  end
end
