describe Cupid::Server do
  subject { Cupid::Server.new 'account' }

  its(:account) { 'account' }

  context '#input' do
    let(:input) { subject.input action }

    context '#for :get_system_status action' do
      let(:action) { :get_system_status }
      let(:tag_name) { 'SystemStatusRequestMsg' }

      it { input.should == [tag_name, :xmlns => Cupid::NAMESPACE] }
    end

    context '#for :unexisting action' do
      let(:action) { :unexisting }

      it { expect { input }.to raise_error }
    end
  end
end
