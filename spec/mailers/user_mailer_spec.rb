require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  context "アカウントアクティベーションの時" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.account_activation(user) }
    before do
      user.activation_token = User.new_token
    end

    it "件名は Account activation" do
      expect(mail.subject).to eq("Account activation")
    end

    it 'メールの宛先はユーザーのメールアドレスになる' do
      expect(mail.to).to eq([user.email])
    end

    it 'メールの送り主は noreply@example.com' do
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it 'bodyにアクティベーショントークンが含まれている' do
      expect(mail.body.encoded).to match(user.activation_token)
    end

    it 'bodyにエスケープされたメールアドレスが含まれている' do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end

  context "パスワードリセットの時" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.password_reset(user) }
    before do
      user.reset_token = User.new_token
    end

    it "件名は Password reset" do
      expect(mail.subject).to eq("Password reset")
    end

    it 'メールの宛先はユーザーのメールアドレスになる' do
      expect(mail.to).to eq([user.email])
    end

    it 'メールの送り主は noreply@example.com' do
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it 'bodyにリセットトークンが含まれている' do
      expect(mail.body.encoded).to match(user.reset_token)
    end

    it 'bodyにエスケープされたメールアドレスが含まれている' do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end
