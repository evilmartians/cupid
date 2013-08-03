class Cupid
  module Response

    class ResponseObject

      attr_reader :results

      def initialize(body, check)
        @data = Data.new(body, check)
        @results = cast formatted @data.results
      end

      def has_more?
        @data.has_more?
      end

      def request_id
        @data.request_id
      end

      private

      def formatted(raw_data)
        raw_data.map {|it| Format.apply it }
      end

      def cast(data)
        data.map {|it| Caster.create it }
      end

    end

    class << self
      
      def parse(body, check, return_results)
        if return_results
          ResponseObject.new(body, check).results
        else
          ResponseObject.new(body, check)
        end
      end

    end
  end
end
