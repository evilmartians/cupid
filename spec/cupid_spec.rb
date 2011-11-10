describe Cupid do
  subject { Cupid.new 'bob', 'x123', 42 }

  its(:client) { should be }
  its('client.wsse.username') { should == 'bob' }
  its('client.wsse.password') { should == 'x123' }
  its(:account) { should == 42 }

  def stub_input(value)
    Cupid::Node.stub(:input).with(:action).and_return [value]
  end

  def soap_should_receive(text)
    stub_request(:post, Cupid::ENDPOINT).
      with(:body => /#{text}/).
      to_return(:body => Savon::SOAP::XML.new.to_xml)
  end

  it 'uses correct input' do
    stub_input :correct_input
    soap_should_receive :correct_input
    subject.request :action
  end
end
