class TestModel <Cupid::Models::Base

  map_fields :id =>   "ID",
             :name => "Name"

end

describe Cupid::Filter do
  let(:simple_type){ { "xsi:type" => "SimpleFilterPart" } }
  let(:complex_type){ { "xsi:type" => "ComplexFilterPart" } }

  let(:name_filter){ { :value => "foo", :simple_operator => "equals", :property => "Name" } }
  let(:id_filter){ { :value => 1, :simple_operator => "equals", :property => "ID" } }
  
  let(:simple_name_filter){ { :filter => name_filter, :attributes! => { :filter => simple_type } } }
  let(:simple_id_filter){ { :filter => id_filter, :attributes! => { :filter => simple_type } } }

  let(:complex_filter){ { :filter => { :logical_operator => "AND",
                                       :left_operand => name_filter,
                                       :right_operand => id_filter,
                                       :attributes! => { :left_operand => simple_type,
                                                         :right_operand => simple_type } },
                          :attributes! => { :filter => complex_type } } }

  it "should work with procs" do
    TestModel.create_filter(proc{ name == "foo" }).should == simple_name_filter
    TestModel.create_filter{ name ==  "foo"}.should == simple_name_filter
    TestModel.create_filter{ (name == "foo") & (id == 1) }.should == complex_filter
    TestModel.create_filter(proc{ (name == "foo") & (id == 1) }).should == complex_filter
  end

  it "should work with hashes" do
    TestModel.create_filter(:name => "foo").should == simple_name_filter
    TestModel.create_filter(:name => "foo", :id => 1).should == complex_filter
  end

end
