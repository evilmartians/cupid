require 'cupid/configuration'

module Cupid
  extend Configuration

  def self.configure
    yield self if block_given?
  end

end
