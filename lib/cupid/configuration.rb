require("erb")
require("uri")
require("savon")
require("logger")
require("builder")
require("net/https")
require("cupid/session")

include(ERB::Util)

module Cupid
  module Configuration
    attr_accessor(
      :username,
      :password,
      :api_type
    )
  end
end