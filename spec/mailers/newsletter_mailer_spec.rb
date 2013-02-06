require "spec_helper"

describe NewsletterMailer do
  describe "weekly" do
    let(:mail) { NewsletterMailer.weekly }

    it "renders the headers" do
      mail.subject.should eq("Weekly")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
