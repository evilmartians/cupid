require 'webmock/rspec'
require 'cupid'

WebMock.allow_net_connect!

Savon.log = false
HTTPI.log = false

test_credentials = YAML.load_file('.test_account')
Cupid::Test = Cupid.new *test_credentials

RSpec.configure do |config|
  config.mock_with :rspec
end
