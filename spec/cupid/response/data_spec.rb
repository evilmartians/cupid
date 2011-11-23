describe Cupid::Response::Data do
  subject { described_class.from response }

  let(:response) {{
    :body => {
      :overall_status => status,
      :results => result
    }
  }}

  describe 'unsuccessful response' do
    let(:status) { 'some error' }

    shared_examples_for 'response error' do
      it { expect { subject }.to raise_exception described_class::Error, error_text }
    end

    context 'with status message' do
      let(:result) {{ :status_message => error_text }}
      let(:error_text) { 'bad_request' }

      it_should_behave_like 'response error'
    end

    context 'without status message' do
      let(:result) { nil }
      let(:error_text) { status }

      it_should_behave_like 'response error'
    end
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
