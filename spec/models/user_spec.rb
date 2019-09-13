require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)  { create(:user, :michael) }
  let(:other) { create(:user, :archer) }

  context "有効なユーザーの時" do
    it "valid となる" do
      expect(user).to be_valid
    end
  end

  context "name属性" do
    it "空だとinvalid" do
      user.name = " "
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "50文字以上だとinvalid" do
      user.name = "a" * 51
      user.valid?
      expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
    end
  end

  context "email属性" do
    it "空だとinvalid" do
      user.email = " "
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "255文字以上だとinvalid" do
      user.email = "a" * 244 + "@example.com"
      user.valid?
      expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
    end

    it "有効なメールフォーマットだとvalid" do
      user.email = "A_US-ER@foo.bar.org"
      expect(user).to be_valid
    end

    it "無効なメールフォーマットだとinvalid" do
      user.email = "user_at_foo.org"
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "一意性がないとinvalid" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      duplicate_user.valid?
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end
  end

  context "password属性" do
    it "空だとinvalid" do
      user.password = " "
      expect(user).to be_invalid
    end

    it "短すぎるとinvalid" do
      user.password = user.password_confirmation = "a" * 5
      expect(user).to be_invalid
    end
  end

  describe "#authenticated?" do
    context "ダイジェストが空だとfalse" do
      it { expect(user.authenticated?(:remember, '')).to be_falsey }
    end
  end

  context "ユーザー削除の時" do
    it "投稿した記事も消えているとvalid" do
      user.microposts.create!(content: "Lorem ipsum")
      expect{ user.destroy }.to change{ Micropost.count }.by(-1)
    end
  end

  context "フォローする時" do
    it "フォローしていないとfollowingはfalseが返る" do
      expect(user.following?(other)).to be_falsey
    end

    it "フォローするとfollowingはtrueが返る" do
      user.follow(other)
      expect(user.following?(other)).to be_truthy
    end

    it "フォローしたユーザーのfollowersに含まれる" do
      user.follow(other)
      expect(other.followers).to include user
    end
  end

  context "フォローを解除する時" do
    it "following?はfalseが返る" do
      user.follow(other)
      user.unfollow(other)
      expect(user.following?(other)).to be_falsey
    end
  end

  context "フィードを確認する時" do
    it "自分の投稿も見える" do
      user.microposts.create!(content: "example post")
      expect(user.feed.map(&:user_id)).to include user.id
    end

    it "フォローしたユーザーの投稿が見える" do
      user.follow(other)
      other.microposts.create!(content: "fooo!!")
      expect(user.feed.map(&:user_id)).to include other.id
    end

    it "解除したユーザーの投稿は見えない" do
      user.follow(other)
      other.microposts.create!(content: "fooo!!")
      user.unfollow(other)
      expect(user.feed.map(&:user_id)).to_not include other.id
    end
  end
end
