class Cupid
  module Response
    class Object
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def type
        self[:'@xsi:type']
      end

      def id
        data[:id] || data[:new_id]
      end

      def [](attribute)
        data[attribute] || data[:object][attribute]
      end
    end
  end
end
