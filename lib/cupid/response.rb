class Cupid
  module Response
    def self.parse(wrapped_body)
      Data.from(wrapped_body).map &Object.method(:new)
    end
  end
end
