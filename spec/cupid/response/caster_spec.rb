describe Cupid::Response::Caster, '.create' do
  subject { described_class.create :type => type }
  Cupid::Response::SomeType = Class.new Cupid::Response::Object

  context 'no type' do
    let(:type) { nil }
    it { should be_a Cupid::Response::Object }
  end

  context 'type without class' do
    let(:type) { :type_without_class }
    it { should be_a Cupid::Response::Object }
  end

  context 'type with class' do
    let(:type) { :some_type }
    it { should be_a Cupid::Response::SomeType }
  end
end
