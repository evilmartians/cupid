describe Cupid::Retrieve do
  subject { Cupid::Test }

  its(:folders)     { should be_success }
  its(:emails)      { should be_success }
  its(:lists)       { should be_success }
  its(:deliveries)  { should be_success }
end
