class Cupid
  module Response
    class Format
      IGNORED_FIELDS = [:partner_key, :object_id]

      def self.apply(data)
        formatted = new data
        formatted.data
      end

      attr_reader :data

      def initialize(data)
        @data = data
        extract_nested
        unify_id
        drop_xsi_prefix
        delete_ignored_fields
      end

      private

      def extract_nested
        data.merge! data.delete(:object) if data[:object]
      end

      def unify_id
        data[:id] ||= data.delete(:new_id)
      end

      def drop_xsi_prefix
        data.keys.select {|it| it.to_s.include? '@xsi' }.each do |key|
          new_key = key.to_s.split(':').last.to_sym
          data[new_key] = data.delete key
        end
      end

      def delete_ignored_fields
        data.delete_if {|key,_| IGNORED_FIELDS.include? key }
      end
    end
  end
end
