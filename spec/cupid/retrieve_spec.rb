describe Cupid::Retrieve do
  subject { Cupid::Test }

  its(:folders)     { should be }
  its(:emails)      { should be }
  its(:lists)       { should be }
  its(:deliveries)  { should be }
  its(:ui_folders)  { should be }
  its(:ui_emails)   { should be }

  it { subject.emails('unexisting name').should == [] }
end
