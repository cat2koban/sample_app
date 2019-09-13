require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user, :michael) }
  before do
    @micropost = create(:micropost, user: user)
  end

  context "有効なマイクロポストを作成した時" do
    it "validとなる" do
      expect(@micropost).to be_valid
    end
  end

  context "無効なマイクロポストを作成した時" do
    it "user_idが無いと，invalidとなる" do
      @micropost.user_id = nil
      @micropost.valid?
      expect(@micropost.errors[:user_id]).to include("can't be blank")
    end

    it "contentが無いと，invalidとなる" do
      @micropost.content = "  "
      @micropost.valid?
      expect(@micropost.errors[:content]).to include("can't be blank")
    end

    it "contentが140文字以上だと，invalidとなる" do
      @micropost.content = "a" * 141
      @micropost.valid?
      expect(@micropost.errors[:content]).to include("is too long (maximum is 140 characters)")
    end
  end

  context "マイクロポストを取得する時" do
    it "最新のマイクロポストが取得できるとvalidとなる" do
      expect(user.microposts.create(attributes_for(:micropost, :most_recent))).to eq Micropost.first
    end
  end
end
