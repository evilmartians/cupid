describe Cupid::Response do
  let(:savon_body) {{
    :response => {
      :overall_status => status,
      :results => result
    }
  }}

  subject do
    Cupid::Response.new double 'savon-response', :body => savon_body
  end

  context 'success' do
    let(:status) { 'OK' }
    let(:result) { [:object] }

    its(:success?) { should be true }
    its(:result) { should == [:object] }
    its(:first) { should == :object }
    its(:size) { should == 1 }
  end

  context 'failure' do
    let(:status) { 'Error' }
    let(:result) {{ :status_message => 'Bad request' }}

    its(:success?) { should be false }
    it { expect { subject.result }.to raise_exception(Cupid::Response::Error) }
  end
end
