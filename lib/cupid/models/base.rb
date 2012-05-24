class Cupid
  module Models
    class Base

      class <<self

        def properties
          field_spec.values.collect{ |spec| spec[:property] }
        end

        def field_spec
          raise NotImplementedError.new "call map_fields for model subclass"
        end

        def convert_spec
          {}
        end

        protected

        def map_fields(fields)
          field_spec = {}
          path_re = /(?<=[a-z])[A-Z]/
          fields.each_pair do |name, property|
            if property.is_a? Hash
              field_spec[name] = property
              property = property[:property]
            else
              field_spec[name] = {
                :property => property,
                :path => property.gsub(path_re){ |m| "_#{m.downcase}" }.downcase
              }              
            end
            (class << self; self; end).instance_eval do
              define_method(name) { Filter::send property }
            end
            attr_reader name
          end
          (class << self; self; end).instance_eval do
            define_method(:field_spec) { field_spec }
          end
        end

        def convert(name, &blk)
          spec = convert_spec.merge name => blk
          (class << self; self; end).instance_eval do
            define_method(:convert_spec) { spec }
          end
        end

      end

      def initialize(hash)
        self.class::field_spec.each_pair do |name, spec|
          instance_variable_set "@#{name}", extract_value(hash, spec[:path])
        end
        self.class::convert_spec.each_pair do |name, blk|
          if instance_variable_get "@#{name}"
            instance_variable_set "@#{name}", blk.call(instance_variable_get("@#{name}"))
          end
        end
      end

      protected

      def extract_value(hash, path)
        chunks = path.split "."
        root = hash
        while chunks.any? and root
          root = root[chunks.shift.to_sym]
        end
        root
      end

    end
  end
end
