require 'webmock/rspec'
require 'cupid'

Savon.log = false
HTTPI.log = false

RSpec.configure do |config|
  config.mock_with :rspec
end
