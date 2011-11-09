class Cupid
  module Filter
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
