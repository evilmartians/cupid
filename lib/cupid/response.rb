class Cupid
  class Response
    include Enumerable
    Error = Class.new StandardError

    attr_reader :body

    def self.empty
      new :body => { :overall_status => 'OK' }
    end

    def initialize(wrapped_body)
      extract wrapped_body
      check_errors!
    end

    def result
      body[:results] || []
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
      body[:overall_status]
    end

    def error_message
      body[:results][:status_message]
    end

    def check_errors!
      raise Error.new error_message unless status == 'OK'
    end

    def extract(wrapped_body)
      @body = wrapped_body.values.first
    end
  end
end
