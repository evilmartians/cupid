class Cupid
  class Response
    def self.parse(wrapped_body)
      Data.from wrapped_body
    end
  end
end
