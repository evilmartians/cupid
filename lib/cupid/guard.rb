class Cupid
  module Guard

    def protect_with_guard(method_name, *specs)
      unprotected_method = instance_method(method_name)
      define_method method_name do |*args, &blk|
        check_args = args.dup
        check_args.push blk if blk
        check_arity = true
        puts "guard checks args #{check_args}"
        specs.each_with_index do |spec, index|
          if spec.is_a? Rest
            unless spec.check(check_args)
              raise ArgumentError.new "Cupid##{method_name} requires rest args of type #{spec.type_name}"
            end
            check_arity = false
          else
            unless spec.check(check_args.shift)
              raise ArgumentError.new "Cupid##{method_name} requires #{index} arg to be #{spec.type_name}"
            end
          end
        end
        if check_arity
          unless check_args.empty?
            raise ArgumentError.new "Cupid##{method_name} accepts #{unprotected_method.arity} args"
          end
        end
        puts "call #{method_name} with #{args} and #{blk}"
        unprotected_method.bind(self).call *args, &blk
      end
    end

    class String

      def self.check(val)
        val.is_a? Object::String
      end

      def self.type_name
        "String"
      end

    end

    class Integer

      def self.check(val)
        val.is_a? Object::Integer
      end

      def self.type_name
        "Integer"
      end

    end

    class Symbol

      def self.check(val)
        val.is_a? Object::Symbol
      end

      def self.type_name
        "Symbol"
      end

    end

    class Proc

      def self.check(val)
        val.nil? || val.is_a?(Object::Proc)
      end

      def self.type_name
        "Proc"
      end

    end

    class Array

      def self.[](guard)
        new guard
      end

      def initialize(guard)
        @guard = guard
      end

      def check(val)
        val.reject{ |item| @guard.check item }.empty?
      end

      def type_name
        "Array[#{@guard.type_name}]"
      end

    end

    class Rest < Array

      def type_name
        @guard.type_name
      end

    end

  end
end
