class Cupid
  module Models
    class SubscriberSet < Cupid::Models::Set

      def add_to_list(list)
        obj = @cupid.server.objects "Subscriber", self.collect{ |sub|
          {
            :subscriber_key => sub.key,
            :lists => [{
              :ID => list.id,
              :status => "Active",
              :action => "create"
            }]
          }
        }
        @cupid.resources :update, obj, false
      end

    end
  end
end
