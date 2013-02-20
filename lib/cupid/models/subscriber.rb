class Cupid
  module Models
    class Subscriber < Base

      map_fields :id           => "ID",
                 :email        => "EmailAddress",
                 :key          => "SubscriberKey",
                 :unsubscribed => "UnsubscribedDate"

      convert(:id) { |id| id.to_i }
      convert(:key) { |key| key.to_i }

      has_many(:ListSubscriber) { |sub, list_sub| (list_sub.subscriber_key == sub.key) & (list_sub.status == "Active") }

      def lists
        if @cached_lists.nil?
          list_ids = list_subscribers.collect(&:list_id)
          if list_ids.empty?
            @cached_lists = []
          else
            @cached_lists = @cupid.retrieve(:List){ id =~ list_ids }.reject &:nil?
          end
        end
        @cached_lists
      end

      def add_to_list(list)
        SubscriberSet.new(@cupid, :Subscriber, [self]).add_to_list(list).first
      end

    end
  end
end
