describe Cupid::Delete do
  subject { Cupid::Test }

  shared_examples_for 'deletion' do
    let(:email) { subject.create_email email_name, 'body' }
    let(:email_id) { email[:new_id] }
    let(:email_name) { 'subject' }

    it { deletion.should be_success }
    it { subject.emails.each {|it| it.should_not include(:id => email_id) }}
  end
  context '#delete_emails' do
    let(:deletion) { subject.delete_emails [email_id] }
    it_should_behave_like 'deletion'
  end

  context '#delete_emails_like' do
    let(:deletion) { subject.delete_emails_like email_name }
    it_should_behave_like 'deletion'
  end
end
