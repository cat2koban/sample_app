require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user)    { create(:user) }
  let(:michael) { create(:user, :michael) }
  let(:relationship) {
    Relationship.new(followed_id: user.id, follower_id: michael.id)
  }
  describe '有効なリレーションシップを作成した時' do
    it "validとなる" do
      expect(relationship).to be_valid
    end

    it "DBへの保存が成功する" do
      relationship.save
      expect(relationship).to be_persisted
    end
  end

  describe '無効なリレーションシップを作成した時' do
    it "followed_idが空だとinvalidとなる" do
      relationship.followed_id = nil
      expect(relationship).to be_invalid
    end

    it "follower_idが空だとinvalidとなる" do
      relationship.follower_id = nil
      expect(relationship).to be_invalid
    end

    it "同じリレーションを作成してもDBに保存されない" do
      @invalid_relationship = Relationship.new(
        follower_id: user.id,
        followed_id: michael.id
      )
      relationship.save
      @invalid_relationship.save
      #expect(relationship).to be_persisted
      expect(@invaid_relationship).to be_nil
    end
  end
end
