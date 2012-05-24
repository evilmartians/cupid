class Cupid
  module Models
    class List < Base

      map_fields :id           => "ID",
                 :name         => "ListName",
                 :customer_key => "CustomerKey"

      convert(:id) { |id| id.to_i }

    end
  end
end
