class Cupid
  module Node
    extend self

    INPUT_NAMES = {
      :version_info       => 'VersionInfoRequestMsg',
      :get_system_status  => 'SystemStatusRequestMsg',
      :retrieve           => 'RetrieveRequestMsg'
    }

    def input(action)
      [INPUT_NAMES.fetch(action), :xmlns => Cupid::NAMESPACE]
    end

    def filter(field, operator, value)
      {
        :filter => { 
          :property => field, 
          :simple_operator => operator, 
          :value => value
        },
        :attributes! => { 
          :filter => { 'xsi:type' => 'SimpleFilterPart' }
        }
      }
    end
  end
end
