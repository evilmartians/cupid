class Cupid
  class Response
    include Enumerable

    attr_accessor :body

    Error = Class.new StandardError

    def self.ok
      allocate.tap {|it| it.body = { :overall_status => 'OK' }}
    end

    def initialize(savon_response)
      @body = savon_response.body.values.first
    end

    def success?
      status == 'OK'
    end

    def result
      raise_unless_success
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
      @body[:overall_status]
    end

    def raise_unless_success
      raise Error, body[:results][:status_message] unless success?
    end
  end
end
