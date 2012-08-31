class Cupid
  module Models
    class EmailSendDefinition < Base

      map_fields :email_id       => "Email.ID",
                 :customer_key   => "CustomerKey",
                 :name           => "Name",
                 :email_subject  => "EmailSubject",
                 :category_id    => "CategoryID",
                 :sender_name    => "SenderProfile.FromName",
                 :sender_address => "SenderProfile.FromAddress",
                 :list_ids       => "SendDefinitionList"

      convert(:category_id) { |category_id| category_id.to_i }
      convert(:email_id) { |email_id| email_id.to_i }

      convert(:list_ids) do |list_ids|
        [list_ids].flatten.collect do |list_spec|
          list_spec[:list][:id].to_i
        end
      end

      belongs_to(:Email) { |send_def, email| email.id == send_def.email_id }
      has_many(:Send){ |send_def, s| s.send_def_key == send_def.customer_key }
      has_many(:List) { |send_def, list| list.id =~ send_def.list_ids }

      def delete_repr
        raise "model is not associated with Cupid instance" unless @cupid
        {
          customer_key: customer_key,
          client: { id: @cupid.server.account }
        }
      end

      def perform!
        resp = @cupid.resource :perform,
          action: "start",
          definitions: {
            definition: {
              customer_key: customer_key,
              client: { id: @cupid.server.account },
            },
            attributes!: {
              definition: { "xsi:type" => "EmailSendDefinition" }
            }
          }
        resp.data[:result][:task][:id].to_i
      end

    end
  end
end
