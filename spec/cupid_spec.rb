require 'cupid'

describe Cupid do
  subject { Cupid.new 'bob', 'x123', 42 }

  it { should be }
  its(:username) { should == 'bob' }
  its(:password) { should == 'x123' }
  its(:account) { should == 42 }
end
