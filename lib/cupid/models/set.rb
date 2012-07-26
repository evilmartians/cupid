class Cupid
  module Models
    class Set < Array

      def initialize(cupid, type, items)
        super(items)
        @type = type
        @cupid = cupid
      end

      def delete!
        if any?
          objects = {
            :objects => collect(&:delete_repr),
            :attributes! => {
              :objects => {
                "xsi:type" => @type
              }
            }
          }
          if self[0].class.properties.include? "ID"
            @cupid.logger.info "DELETE #{@type} WHERE ID IN (#{collect(&:id).join(', ')})"
          else
            @cupid.logger.info "DELETE #{count} #{@type}"
          end
          @cupid.resources :delete, objects
        end
      end

    end
  end
end
