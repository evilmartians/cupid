class Cupid
  module Models
    class ListSubscriber < Base

      map_fields :id => "ID",
                 :list_id => "ListID",
                 :subscriber_key => "SubscriberKey",
                 :status => "Status"

      convert(:id){ |id| id.to_i }
      convert(:list_id) { |list_id| list_id.to_i }

      belongs_to(:Subscriber) { |list_sub, sub| sub.key == list_sub.subscriber_key }
      belongs_to(:List) { |list_sub, list| list.id == list_sub.list_id }

    end
  end
end
