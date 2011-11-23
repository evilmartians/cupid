class Cupid
  class Response
    class Data
      Error = Class.new StandardError

      def self.from(wrapped_body)
        new(wrapped_body).results
      end

      def initialize(wrapped_body)
        extract wrapped_body
        check_status!
      end

      def results
        [body[:results]].compact.flatten
      end

      private

      attr_reader :body

      def extract(wrapped_body)
        @body = wrapped_body.values.first
      end

      def check_status!
        raise Error.new error_message unless success?
      end

      def success?
        status == 'OK'
      end

      def status
        body[:overall_status]
      end

      def error_message
        body[:results][:status_message]
      end
    end
  end
end
