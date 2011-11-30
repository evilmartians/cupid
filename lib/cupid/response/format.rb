class Cupid
  module Response
    class Format
      IGNORE = [:partner_key, :object_id]
      RENAME = {
        :new_id        => :id,
        :'@xsi:type'   => :type,
        :parent_folder => :parent_data
      }

      def self.apply(data)
        formatted = new data
        formatted.data
      end

      attr_reader :data

      def initialize(data)
        @data = data
        extract_nested_data
        rename_fields
        delete_ignored_fields
        delete_empty_parents
      end

      private

      def extract_nested_data
        data.merge! data.delete(:object) if data[:object]
      end

      def rename_fields
        RENAME.each do |old_name, new_name|
          next unless data[old_name]
          data[new_name] = data.delete old_name
        end
      end

      def delete_ignored_fields(data=@data)
        data.delete_if do |key, value|
          delete_ignored_fields value if value.is_a? Hash
          IGNORE.include? key
        end
      end

      def delete_empty_parents
        if (data[:parent_data] || {})[:id] == '0'
          data.delete :parent_data
        end
      end
    end
  end
end
