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
      end
      it 'リレーションが作成される' do
        log_in_as(user)
        relationship_count = Relationship.count
        is_expected.to eq(302)
        expect(response.body).to redirect_to(user_path(other_user))
        expect(Relationship.count).to eq(relationship_count+1)
      end
    end
  end

  describe 'DELETE /relationships/:id' do
    let(:user)         { create(:user) }
    let(:other_user)   { create(:other_user) }
    let(:relationship) {
      Relationship.create(
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
end
