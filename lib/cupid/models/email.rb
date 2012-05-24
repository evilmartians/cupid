class Cupid
  module Models
    class Email < Base

      map_fields :id   => "ID",
                 :name => "Name"

      convert(:id) { |id| id.to_i }

    end
  end
end
