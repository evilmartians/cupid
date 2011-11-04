require 'cupid/version'

class Cupid
  attr_reader :username, :password, :account

  def initialize(username, password, account)
    @username = username
    @password = password
    @account  = account
  end
end
