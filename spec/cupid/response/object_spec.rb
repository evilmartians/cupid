describe Cupid::Response::Object do
  subject { described_class.new data }

  describe 'accessor for attributes' do
    let(:data) {{ :foo => :bar }}

    it { subject[:foo].should == :bar }
  end

  context 'direct accessors' do
    let(:data) {{ :id => 42, :type => 'Email' }}

    its(:id) { should == 42 }
    its(:type) { should == 'Email' }
  end

  context 'gyoku compatibility' do
    let(:id) { 77 }
    let(:data) {{ :id => id }}

    it { Gyoku.xml(:object => subject).should == "<Object>#{id}</Object>" }
  end
end
