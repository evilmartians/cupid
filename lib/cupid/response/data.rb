class Cupid
  module Response
    class Data
      Error = Class.new StandardError

      def self.from(wrapped_body, check)
        new(wrapped_body, check).results
      end

      def initialize(wrapped_body, check)
        extract wrapped_body
        check_status! if check
      end

      def results
        [raw_results].compact.flatten
      end

      def has_more?
        status == "MoreDataAvailable"
      end

      def request_id
        body[:request_id]
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
        if raw_results and raw_results.is_a? Hash
          raw_results[:status_message]
        else
          status
        end
      end
    end
  end
end
