describe Cupid::Response::Format, '.apply' do
  def apply(data)
    described_class.apply data
  end

  it 'should return hash with original data' do
    simple_data = { :a => 1 }
    apply(simple_data).should include :a => 1
  end

  context 'contains new_id' do
    it 'should use new_id if id is missing' do
      new_data = { :new_id => 42 }
      apply(new_data).should include :id => 42
    end

    it 'should not use new_id if id is present' do
      old_data = { :new_id => 42, :id => 239 }
      apply(old_data).should include :id => 239
    end
  end

  context 'contains nested definition' do
    it 'should extract nested object to the top level' do
      nested_data = { :a => 1, :object => { :b => 2 }}
      apply(nested_data).should include :a => 1, :b => 2
    end

    it 'should use new_id from nested definition' do
      new_nested_data = { :object => { :new_id => 24 }}
      apply(new_nested_data).should include :id => 24
    end
  end

  context 'contains xsi data' do
    it 'should drop xsi prefix' do
      xsi_data = { :'@xsi:type' => :object }
      apply(xsi_data).should include :type => :object
    end
  end
end
