class Cupid
  module Response
    class Object
      def self.fields(*names)
        names.each do |name|
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{name}
              data[:#{name}]
            end
          RUBY
        end
      end

      attr_reader :data
      fields :id, :customer_key

      def initialize(data)
        @data = data
      end

      # Hook into gyoku
      def call
        id
      end

      def type
        instance_of?(Object) ? self[:type] : self.class
      end

      def ==(object)
        return false unless object.is_a? Cupid::Response::Object
        id and [id, type] == [object.id, object.type]
      end

      def [](field)
        data[field]
      end
    end
  end
end
