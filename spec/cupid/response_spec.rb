describe Cupid::Response do
  let(:savon_body) {{
    :response => {
      :overall_status => status,
      :results => result
    }
  }}

  subject do
    Cupid::Response.new savon_body
  end

  context '.empty' do
    subject { Cupid::Response.empty }

    its(:result) { should == [] }
  end

  context 'success' do
    let(:status) { 'OK' }
    let(:result) { [:object] }

    its(:result) { should == [:object] }
    its(:first) { should == :object }
    its(:size) { should == 1 }
  end

  context 'failure' do
    let(:status) { 'Error' }
    let(:result) {{ :status_message => 'Bad request' }}

    it { expect { subject }.to raise_exception(Cupid::Response::Error) }
  end
end
