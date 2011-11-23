describe Cupid::Delete do
  subject { Cupid::Test }

  shared_examples_for 'deletion' do
    let(:email) { subject.create_email email_name, 'body' }
    let(:email_name) { 'subject' }

    it { deletion.should be }
    it { subject.emails.should_not include(email) }
  end

  context '#delete_emails' do
    let(:deletion) { subject.delete_emails email }
    it_should_behave_like 'deletion'
  end

  context '#delete_emails_like' do
    let(:deletion) { subject.delete_emails_like email_name }
    it_should_behave_like 'deletion'
  end
end
