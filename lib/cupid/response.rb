class Cupid
  class Response
    include Enumerable

    attr_reader :body

    Error = Class.new StandardError

    def initialize(savon_response)
      @body = savon_response.body.values.first
    end

    def success?
      status == 'OK'
    end

    def result
      body[:results].tap do |it|
        raise Error, it[:status_message] unless success?
      end
    end

    %w(each size last []).each do |method|
      class_eval <<-RUBY
        def #{method}(*args, &block)
          result.send :#{method}, *args, &block
        end
      RUBY
    end

    private

    def status
      @body[:overall_status]
    end
  end
end
