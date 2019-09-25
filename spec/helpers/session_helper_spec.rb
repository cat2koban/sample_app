require 'rails_helper'

RSpec.describe SessionsHelper do
  include SessionsHelper
  let(:user) { create(:user) }
  before do
    remember(user)
  end

  context 'セッションがnilの場合' do
    it '正しいユーザーを返す' do
      expect(current_user).to eq(user)
    end
  end

  context 'ダイジェストの記憶が間違っている場合' do
    it 'nilを返す' do
      user.update_attributes(remember_digest: User.digest(User.new_token))
      expect(current_user).to be_nil
    end
  end
end
