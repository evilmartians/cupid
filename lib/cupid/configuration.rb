require 'erb'
require 'uri'
require 'savon'
require 'builder'
require 'nokogiri'
require 'cupid/session'

include(ERB::Util)

module Cupid
  module Configuration
    attr_accessor(
      :username,
      # :api_type, #now it's only soap s4. But i want MOAR
      :password
    )
  end
end