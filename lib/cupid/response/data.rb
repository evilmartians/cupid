class Cupid
  module Response
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
        [raw_results].compact.flatten
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
        body[:object_definition] || %w(MoreDataAvailable OK).include?(status)
      end

      def status
        body[:overall_status]
      end

      def raw_results
        body[:results] || body[:object_definition]
      end

      def error_message
        raw_results ? raw_results[:status_message] : status
      end
    end
  end
end
