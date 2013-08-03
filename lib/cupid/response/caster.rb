require "active_support/core_ext/string/inflections"

class Cupid
  module Response
    module Caster
      class << self
        def create(data)
          klass = class_for data[:type]
          klass.new data
        end

        private

        def class_for(type)
          fetch_constant class_name(type)
        end

        def fetch_constant(name)
          if namespace.const_defined? name
            namespace.const_get name
          else
            namespace::Object
          end
        end

        def namespace
          Cupid::Response
        end

        def class_name(type)
          (type || :object).to_s.camelcase
        end
      end
    end
  end
end
