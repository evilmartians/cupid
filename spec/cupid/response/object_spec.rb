describe Cupid::Response::Object do
  subject { described_class.new data }

  describe 'accessor for attributes' do
    let(:data) {{ :foo => :bar }}
    it { subject[:foo].should == :bar }
  end

  context 'from retrival' do
    let(:data) {{ :id => 42, :'@xsi:type' => 'Email' }}
    its(:id) { should == 42 }
    its(:type) { should == 'Email' }
  end

  context 'from creation' do
    let(:data) {{ :new_id => 7, :object => { :'@xsi:type' => 'DataFolder' }}}
    its(:id) { should == 7 }
    its(:type) { should == 'DataFolder' }
  end
end
