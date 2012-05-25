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

        def convert_name(name)
          name.to_s.gsub(/(?<=[a-z])[A-Z]/){ |m| "_#{m.downcase}" }.downcase
        end

        def map_fields(fields)
          field_spec = {}
          fields.each_pair do |name, property|
            if property.is_a? Hash
              field_spec[name] = property
              property = property[:property]
            else
              field_spec[name] = {
                :property => property,
                :path => convert_name(property)
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

        def convert(name, &converter)
          spec = convert_spec.merge(name => converter)
          (class << self; self; end).instance_eval do
            define_method(:convert_spec) { spec }
          end
        end

        def belongs_to(model, &filter)
          varname = convert_name model
          define_method varname do
            has_cached = instance_variable_get "@has_cached_#{varname}"
            if has_cached
              instance_variable_get "@cached_#{varname}"
            else
              raise "model is not associated with Cupid instance" unless @cupid
              value = @cupid.retrieve_first model, &filter.curry[self]
              instance_variable_set "@has_cached_#{varname}", true
              instance_variable_set "@cached_#{varname}", value
              value
            end
          end
        end

        def has_many(model, &filter)
          varname = convert_name(model) + "s"
          define_method varname do
            hash_cached = instance_variable_get "@hash_cached_#{varname}"
            if hash_cached
              instance_variable_get "@cached_#{varname}"
            else
              raise "model is not associated with Cupid instance" unless @cupid
              value = @cupid.retrieve model, &filter.curry[self]
              instance_variable_set "@hash_cached_#{varname}", true
              instance_variable_set "@cached_#{varname}", value
              value
            end
          end
        end

      end

      def initialize(cupid, hash)
        @cupid = cupid
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
