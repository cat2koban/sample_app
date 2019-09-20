require 'rails_helper'

RSpec.describe MicropostsController, type: :request do
  describe 'POST /microposts' do
    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response.body).to redirect_to(login_path)
      end
    end

    context 'ログインしている時' do
      let(:user)      { create(:user) }
      let(:id)        { user.id }
      before do
        params['micropost'] = { content: "Lorem ipsum" }
      end

      it 'マイクロポストが投稿できる' do
        log_in_as(user)
        microposts_counts = Micropost.count
        is_expected.to eq(302)
        expect(response.body).to redirect_to(root_url)
        expect(flash[:success]).to include("Micropost created!")
        expect(Micropost.count).to eq(microposts_counts+1)
      end
    end
  end

  describe 'DELETE /microposts/:id' do
    context 'ログインしていない時' do
      let(:micropost) { create(:micropost) }
      let(:id)        { micropost.id }

      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response.body).to redirect_to(login_path)
      end
    end

    context 'ログインしている時' do
      let(:user)       { create(:user) }
      let(:id)         { user.microposts.first.id }
      let(:other_user) { create(:other_user) }
      before do
        create(:micropost, user: user)
        create(:other_micropost, user: other_user)
      end

      it 'マイクロポストが削除できる' do
        log_in_as(user)
        micropost_count = Micropost.count
        is_expected.to eq(302)
        expect(flash[:success]).to include("Micropost deleted")
        expect(response.body).to redirect_to(root_url)
        expect(Micropost.count).to eq(micropost_count-1)
      end

      it '他のユーザーが投稿したマイクロポストは削除できない' do
        log_in_as(other_user)
        micropost_count = Micropost.count
        is_expected.to eq(302)
        expect(Micropost.count).to eq(micropost_count)
      end
    end
  end
end
