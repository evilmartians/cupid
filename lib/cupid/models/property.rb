class Cupid
  module Models
    class Property < Base

      map_fields :name => "Name",
                 :type => "DataType"

      convert(:type) { |type| type.downcase.to_sym }

    end
  end
end
