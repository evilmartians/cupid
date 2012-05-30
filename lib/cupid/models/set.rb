class Cupid
  module Models
    class Set < Array

      def initialize(cupid, type, items)
        super(items)
        @type = type
        @cupid = cupid
      end

      def delete!
        objects = {
          :objects => collect(&:delete_repr),
          :attributes! => {
            :objects => {
              "xsi:type" => @type
            }
          }
        }
        @cupid.resources :delete, objects
      end

    end
  end
end
