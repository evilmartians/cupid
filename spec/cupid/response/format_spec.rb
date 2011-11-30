describe Cupid::Response::Format, '.apply' do
  def apply(data)
    described_class.apply data
  end

  it 'should return hash with original data' do
    simple_data = { :a => 1 }
    apply(simple_data).should include :a => 1
  end

  it 'should rename specified fields' do
    described_class::RENAME[:old] = :new
    data_with_renaming = { :old => 33 }
    apply(data_with_renaming).should include :new => 33
  end

  it 'should delete ignore fields' do
    described_class::IGNORE << :extra
    data_with_deletion = { :extra => 103 }
    apply(data_with_deletion).should_not include :extra
  end

  it 'should delete empty parents' do
    data_with_empty_parent = { :parent_data => { :id => '0' }}
    apply(data_with_empty_parent).should_not include :parent_data
  end

  context 'contains nested data' do
    it 'should extract nested object to the top level' do
      nested_data = { :a => 1, :object => { :b => 2 }}
      apply(nested_data).should include :a => 1, :b => 2
    end

    it 'should use new_id from nested definition' do
      new_nested_data = { :object => { :new_id => 24 }}
      apply(new_nested_data).should include :id => 24
    end

    it 'should delete ignored fields' do
      described_class::IGNORE << :nested_extra
      nested_data_with_deletion = { :nexted_extra => 17 }
      apply(nested_data_with_deletion).should_not include :nested_extra
    end
  end
end
