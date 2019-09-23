require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)  { create(:user, :michael) }
  let(:other) { create(:user, :archer) }

  context "有効なユーザーの時" do
    it "validとなる" do
      expect(user).to be_valid
    end
  end

  context "name属性" do
    context "空の時" do
      it "invalidとなる" do
        user.name = " "
        user.valid?
        expect(user.errors[:name]).to include("can't be blank")
      end
    end

    context "50文字以上の時" do
      it "invalidとなる" do
        user.name = "a" * 51
        user.valid?
        expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
      end
    end
  end

  context "email属性" do
    context "空の時" do
      it "invalidとなる" do
        user.email = " "
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end
    end

    context "255文字以上の時" do
      it "invalidとなる" do
        user.email = "a" * 244 + "@example.com"
        user.valid?
        expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
      end
    end

    context "有効なメールフォーマットの時" do
      it "validとなる" do
        user.email = "A_US-ER@foo.bar.org"
        expect(user).to be_valid
      end
    end

    context "無効なメールフォーマットの時" do
      it "invalidとなる" do
        user.email = "user_at_foo.org"
        user.valid?
        expect(user.errors[:email]).to include("is invalid")
      end
    end

    context "一意性が無い時" do
      it "invalidとなる" do
        duplicate_user = user.dup
        duplicate_user.email = user.email.upcase
        duplicate_user.valid?
        expect(duplicate_user.errors[:email]).to include("has already been taken")
      end
    end
  end

  context "password属性" do
    context "空の時" do
      it "invalidとなる" do
        user.password = " "
        expect(user).to be_invalid
      end
    end

    context "短すぎる時" do
      it "invalid" do
        user.password = user.password_confirmation = "a" * 5
        expect(user).to be_invalid
      end
    end
  end

  describe "#authenticated?" do
    context "ダイジェストが空の時" do
      it "falseになる" do
        expect(user.authenticated?(:remember, '')).to be_falsey
      end
    end
  end

  context "ユーザー削除の時" do
    context "投稿した記事も消えている時" do
      it "validとなる" do
        user.microposts.create!(content: "Lorem ipsum")
        expect{ user.destroy }.to change{ Micropost.count }.by(-1)
      end
    end
  end

  describe "#following?" do
    context "フォローしていない時" do
      it "falseが返る" do
        expect(user.following?(other)).to be_falsey
      end
    end

    context "フォローしている時" do
      it "trueが返る" do
        user.follow(other)
        expect(user.following?(other)).to be_truthy
      end

      it "フォローしたユーザーのfollowersに含まれる" do
        user.follow(other)
        expect(other.followers).to include user
      end
    end
  end

  context "フィードを確認する時" do
    it "自分の投稿が見える" do
      user.microposts.create!(content: "example post")
      expect(user.feed.map(&:user_id)).to include user.id
    end

    it "フォローしたユーザーの投稿が見える" do
      user.follow(other)
      other.microposts.create!(content: "fooo!!")
      expect(user.feed.map(&:user_id)).to include other.id
    end

    it "解除したユーザーの投稿が見えない" do
      user.follow(other)
      other.microposts.create!(content: "fooo!!")
      user.unfollow(other)
      expect(user.feed.map(&:user_id)).to_not include other.id
    end
  end
end
