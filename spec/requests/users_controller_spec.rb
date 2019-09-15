require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:user)    { create(:user, :michael) }
  let(:user_id) { user.id }

  describe 'GET /users' do
    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response.body).to include(full_title("Log in"))
      end
    end

    context 'ログインしている時' do
      it 'ユーザー一覧が取得できる' do
      end
    end
  end

  describe 'GET /users/new' do
    it 'ユーザー登録ページが取得できる' do
    end
  end

  describe 'GET /users/:user_id/edit' do
    context 'ログインしてない時' do
      it 'ログインページにリダイレクトされる' do
      end
    end

    context 'ログインしている時' do
      it '編集ページにアクセスできる' do
      end
    end
  end

  describe 'PATCH /user/user_id' do
    context 'ログインしていない時' do
      before do
        params['name']  = user.name,
        params['email'] = user.email
      end
      it 'ログインページにリダイレクトされる' do

      end
    end

    context '異なるユーザーが編集しようとした時' do
      it 'フラッシュで警告を出力し, root_urlにリダイレクトする' do
      end
    end

    context '正しいユーザーによる更新の時' do
      it '情報が更新される' do
      end
    end

    it 'web上からは管理者への変更ができない' do
    end
  end

  describe 'DELETE /user/:user_id' do
    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされる' do
      end
    end

    context '管理者でログインしている時' do
      it 'ユーザーを削除できる' do
      end
    end

    context 'ログインしているが管理者でない時' do
      it 'ユーザーは削除できず,root_urlにリダイレクトする' do
      end
    end
  end

  describe 'GET /users/:user_id/follower' do
    context 'ログインしている時' do
      it 'フォロワー一覧ページが閲覧できる' do
      end
    end

    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされる' do
      end
    end
  end

  describe 'GET /users/:user_id/following' do
    context 'ログインしている時' do
      it 'フォロー中のユーザー一覧ページが閲覧できる' do
      end
    end

    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされる' do
      end
    end
  end
end
