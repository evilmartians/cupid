describe Cupid::Delete do
  subject { Cupid::Test }

  context '#delete_emails' do
    let(:email) { subject.create_email 'subject', 'body' }
    let(:email_id) { email[:new_id] }
    let(:deletion) { subject.delete_emails [email_id] }

    it { deletion.should be_success }
    it { subject.emails.each {|it| it.should_not include(:id => email_id) }}
  end
end
