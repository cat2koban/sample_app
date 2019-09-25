require 'rails_helper'

RSpec.describe RelationshipsController, type: :request do
  describe 'POST /relationships' do
    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response.body).to redirect_to(login_path)
      end
    end

    context 'ログインしている時' do
      let(:user)       { create(:user) }
      let(:other_user) { create(:other_user) }
      before do
        params['followed_id'] = other_user.id
        log_in_as(user)
      end

      it 'リレーションが作成される' do
        relationship_count = Relationship.count
        is_expected.to eq(302)
        expect(response.body).to redirect_to(user_path(other_user))
        expect(Relationship.count).to eq(relationship_count+1)
      end

      it '同じリレーションは作成されない' do
        user.follow(other_user)
        is_expected.to eq(302)
        expect(flash[:danger]).to include("Already followed this user")
      end
    end
  end

  describe 'DELETE /relationships/:id' do
    let(:user)         { create(:user) }
    let(:other_user)   { create(:other_user) }
    let(:relationship) {
      create(
        :relationship,
        follower_id: user.id,
        followed_id: other_user.id
      )
    }
    let(:id) { relationship.id }

    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response.body).to redirect_to(login_path)
      end
    end

    context 'ログインしている時' do
      it 'リレーションを削除できる' do
        log_in_as(user)
        relationship
        relationship_count = Relationship.count
        is_expected.to eq(302)
        expect(response.body).to redirect_to(user_path(other_user))
        expect(Relationship.count).to eq(relationship_count-1)
      end
    end
  end

  describe 'DELETE /relationships/:nonexist_id' do
    let(:user)        { create(:user) }
    let(:nonexist_id) { 999 }

    context 'ログインしている時' do
      it '存在しないリレーションは削除できない' do
        log_in_as(user)
        is_expected.to eq(302)
        expect(flash[:danger]).to include("Unfollowing users cannot be unfollowed")
      end
    end
  end

  describe 'Ajaxを利用したフォロー' do
    let(:user)       { create(:user) }
    let(:other_user) { create(:other_user) }
    let(:relationship) {
      create(
        :relationship,
        follower_id: user.id,
        followed_id: other_user.id
      )
    }
    before do
      log_in_as(user)
    end

    context 'ログインしている時' do
      it 'フォローできる' do
        expect{
          post relationships_path, xhr: true, params: { followed_id: other_user.id }
        }.to change{ Relationship.count }.by(1)
      end

      it 'フォロー解除できる' do
        relationship
        expect{
          delete relationship_path(relationship), xhr: true
        }.to change{ Relationship.count }.by(-1)
      end
    end
  end
end
