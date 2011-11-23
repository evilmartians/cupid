describe Cupid::Response::Data do
  subject { described_class.from response }

  let(:response) {{
    :body => {
      :overall_status => status,
      :results => result
    }
  }}

  describe 'response with error' do
    let(:status) { 'error' }
    let(:result) {{ :status_message => 'bad request' }}
    it { expect { subject }.to raise_exception described_class::Error }
  end

  describe 'successful reponse' do
    let(:status) { 'OK' }

    context 'without results' do
      let(:result) { nil }
      it { should == [] }
    end

    context 'with one result' do
      let(:result) {{ :field => :value }}
      it { should == [{ :field => :value }] }
    end

    context 'with multiple results' do
      let(:result) { [:object1, :object2] }
      it { should == [:object1, :object2] }
    end
  end
end
