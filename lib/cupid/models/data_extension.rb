class Cupid
  module Models
    class DataExtension < Base

      map_fields :object_id => "ObjectID",
                 :name => "Name",
                 :key => "CustomerKey"

    end
  end
end
