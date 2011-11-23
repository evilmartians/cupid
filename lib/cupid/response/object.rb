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
        data[attribute] || subdata[attribute]
      end

      private

      def subdata
        data[:object] || {}
      end
    end
  end
end
