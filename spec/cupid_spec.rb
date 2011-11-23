describe Cupid do
  subject { Cupid.new 'bob', 'x123', 42 }

  its(:client)                { should be }
  its('client.wsse.username') { should == 'bob' }
  its('client.wsse.password') { should == 'x123' }
  its('server.account')       { should == 42 }
end
