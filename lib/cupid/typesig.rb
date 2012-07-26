class Cupid
  module Typesig

    def typesig(method_name, *specs)
      unprotected_method = instance_method(method_name)
      field_specs = []
      index = 0
      while index < specs.size
        spec = specs[index]
        if spec.is_a? Symbol
          index += 1
          unless [:required, :optional, :rest].include? spec
            raise ArgumentError.new "unknown arg type, allowed types are :required, :optional and :rest"
          end
          field_specs.push [spec, specs[index]]
          break if spec == :rest
        else
          field_specs.push [:required, spec]
        end
        index += 1
      end
      define_method method_name do |*args, &blk|
        field_specs.each_with_index do |spec, index|
          type, classes = spec
          classes = [classes].flatten
          val = args[index]
          if type == :required
            valid = false
            classes.each do |cls|
              valid = true if val.kind_of? cls
            end
            raise ArgumentError.new "argument #{index} should be one of [#{classes.collect(&:name).join(', ')}] given #{val.class.name}" unless valid
          elsif type == :optional
            unless args[index].nil?
              valid = false
              classes.each do |cls|
                valid = true if val.kind_of? cls
              end
              raise ArgumentError.new "argument #{index} should be one of [#{classes.collect(&:name).join(', ')}] given #{val.class.name}" unless valid
            end
          elsif type == :rest
            args.slice(index, args.size).each do |val|
              raise ArgumentError.new "rest arguments should be #{cls.name} given #{val.class.name}" unless val.kind_of? cls
            end
          end
        end
        unprotected_method.bind(self).call *args, &blk
      end
    end

  end
end
