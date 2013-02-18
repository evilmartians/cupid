class Cupid
  module Models
    class DataExtensionObject < Base

      map_fields :key => "CustomerKey",
                 :object_id => "ObjectID",
                 :data => "Properties"

    end
  end
end
