describe Cupid::Input do
  subject { Cupid::Input.for action }

  context '#for :get_system_status action' do
    let(:action) { :get_system_status }
    let(:tag_name) { 'SystemStatusRequestMsg' }

    it { should == [tag_name, :xmlns => Cupid::NAMESPACE] }
  end

  context '#for :unexisting action' do
    let(:action) { :unexisting }
    let(:input_creation) { lambda { subject }}

    it { input_creation.should raise_error }
  end
end
