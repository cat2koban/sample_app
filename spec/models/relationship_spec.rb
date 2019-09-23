require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user)    { create(:user) }
  let(:michael) { create(:user, :michael) }
  let(:relationship) {
    Relationship.new(followed_id: user.id, follower_id: michael.id)
  }

  context '有効なリレーションシップを作成した時' do
    it "validとなる" do
      expect(relationship).to be_valid
    end

    it "DBへの保存が成功する" do
      relationship.save
      expect(relationship).to be_persisted
    end
  end

  context '無効なリレーションシップを作成した時' do
    context "followed_idが空の時" do
      it "invalidとなる" do
        relationship.followed_id = nil
        relationship.valid?
        expect(relationship.errors[:followed_id]).to include("can't be blank")
      end
    end

    context "follower_idが空の時" do
      it "invalidとなる" do
        relationship.follower_id = nil
        relationship.valid?
        expect(relationship.errors[:follower_id]).to include("can't be blank")
      end
    end

    context "同じリレーションを作成した時" do
      it "DBに保存されない" do
        invalid_relationship = Relationship.new(
          followed_id: user.id,
          follower_id: michael.id
        )
        relationship.save
        invalid_relationship.save
        expect(relationship).to be_persisted
        expect(invalid_relationship).to_not be_persisted
      end
    end
  end
end
