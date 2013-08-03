class Cupid
  module Models
    class Base

      class <<self

        def properties(names=nil)
          names = field_spec.keys if names.nil?
          names.collect{ |name| field_spec[name][:property] }
        end

        def fake(cupid, id)
          raise NotImplementedError.new "can not fake model with no ID field" unless properties.include? "ID"
          new cupid, :id => id
        end

        def field_spec
          raise NotImplementedError.new "call map_fields for model subclass"
        end

        def convert_spec
          {}
        end

        def inspect
          "Cupid:#{model_name}(#{field_spec.keys.join ', '})"
        end
        
        def to_s
          inspect
        end

        def create_filter(data=nil, &filter_proc)
          if data.is_a? Hash
            data.collect{ |k, v| self.send(k) == v }.inject(:&)
          elsif data.is_a? Proc
            class_eval(&data)
          elsif block_given?
            class_eval(&filter_proc)
          else
            raise "arg for Cupid::Models::Base::create_filter should be Hash or Proc"
          end
        end

        protected

        def convert_name(name)
          name.to_s.gsub(/[a-z][A-Z]/){ |m| "#{m[0].chr}_#{m[1].chr.downcase}" }.downcase
        end

        def map_fields(fields)
          original_name = name.split("::").last.to_sym
          (class << self; self; end).instance_eval do
            define_method(:model_name) { original_name }
          end
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
              define_method(name) { Filter[property] }
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
              this = self
              value = @cupid.retrieve_first model, &lambda{ |other| filter.call(this, other) }
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
              this = self
              value = @cupid.retrieve model, &lambda{ |other| filter.call(this, other) }
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

      def delete_repr
        raise "delete repr is not available for models without `id`" unless self.class::field_spec.keys.include? :id
        raise "model is not associated with Cupid instance" unless @cupid
        {
          "ID" => id,
          :client => {
            "ID" => @cupid.server.account
          }
        }
      end

      def delete!
        Set.new(@cupid, self.class::model_name, [self]).delete!.first
      end

      def inspect
        values = []
        id_str = ""
        self.class.field_spec.keys.each do |key|
          if key == :id
            id_str = "##{id}"
          else
            val = self.send key
            values << "#{key}=#{val.inspect}" if val            
          end
        end
        "<Cupid:#{self.class.model_name}#{@cupid ? '' : ':unbound'}#{id_str}#{values.any? ? " #{values.join ', '}" : ""}>"
      end
      
      def to_s
        inspect
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
