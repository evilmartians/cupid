class Cupid
  module Response
    class << self
      def parse(body)
        cast formatted extracted body
      end

      private

      def extracted(body)
        Data.from body
      end

      def formatted(raw_data)
        raw_data.map {|it| Format.apply it }
      end

      def cast(data)
        data.map {|it| Caster.create it }
      end
    end
  end
end
