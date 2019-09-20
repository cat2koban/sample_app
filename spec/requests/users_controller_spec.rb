require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'GET /users' do
    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response).to redirect_to(login_path)
      end
    end

    context 'ログインしている時' do
      let(:user) { create(:user, :michael) }
      let(:id)   { user.id }

      it 'ユーザー一覧が取得できる' do
        log_in_as(user)
        is_expected.to eq(200)
        expect(response.body).to include(full_title("All users"))
      end
    end
  end

  describe 'GET /users/new' do
    it 'ユーザー登録ページが取得できる' do
      is_expected.to eq(200)
      expect(response.body).to include(full_title("Sign up"))
    end
  end

  describe 'GET /users/:id/edit' do
    let(:user) { create(:user, :michael) }
    let(:id)   { user.id }

    context 'ログインしてない時' do
      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response.body).to redirect_to(login_path)
      end
    end

    context '異なるユーザーが編集しようとした時' do
      let(:other_user) { create(:user, :archer) }

      it 'root_urlにリダイレクトする' do
        log_in_as(other_user)
        is_expected.to eq(302)
        expect(response.body).to redirect_to(root_path)
      end
    end

    context 'ログインしている時' do
      it '編集ページにアクセスできる' do
        log_in_as(user)
        is_expected.to eq(200)
        expect(response.body).to include(full_title("Edit user"))
      end
    end
  end

  describe 'PATCH /users/:id' do
    context 'ログインしていない時' do
      let(:user) { create(:user) }
      let(:id)   { user.id }

      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response.body).to redirect_to(login_path)
      end
    end

    context '正しいユーザーによる更新の時' do
      let(:user) { create(:user, :michael) }
      let(:id)   { user.id }
      before do
        params['user'] = {
          name:  "John",
          email: "john@is.awesome",
          password: "",
          password_confirmation: ""
        }
      end

      it '情報が更新される' do
        log_in_as(user)
        is_expected.to eq(302)
        expect(flash[:success]).to include("Profile updated")
        user.reload
        expect(user.name).to include("John")
        expect(user.email).to include("john@is.awesome")
      end
    end

    context '管理者権限を更新する時' do
      let(:user) { create(:user, :michael) }
      let(:id) { user.id }
      before do
        params['user'] = {
          passowrd: user.password,
          passowrd_confirmation: user.password,
          admin: false
        }
      end

      it '制限により更新されない' do
        is_expected.to eq(302)
        expect(user.reload.admin?).to be_truthy
      end
    end
  end

  describe 'DELETE /users/:id' do
    context 'ログインしていない時' do
      let(:user) { create(:user) }
      let(:id)   { user.id }

      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response.body).to redirect_to(login_path)
      end
    end

    context '管理者でログインしている時' do
      let(:user)       { create(:user, :michael) }
      let(:other_user) { create(:user, :archer) }
      let(:id)         { other_user.id }

      it 'ユーザーを削除できる' do
        log_in_as(user)
        expect(User.all).to include(other_user)
        is_expected.to eq(302)
        expect(response.body).to redirect_to(users_url)
        expect(flash[:success]).to include("User deleted")
        expect(User.all).to_not include(other_user)
      end
    end

    context 'ログインしているが管理者でない時' do
      let(:user) { create(:user, :archer) }
      let(:id)   { user.id }

      it 'ユーザーは削除できず,root_urlにリダイレクトする' do
        log_in_as(user)
        is_expected.to eq(302)
        expect(response.body).to redirect_to(root_url)
      end
    end
  end

  describe 'GET /users/:id/followers' do
    let(:user) { create(:user, :michael)}
    let(:id)   { user.id }

    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response.body).to redirect_to(login_path)
      end
    end

    context 'ログインしている時' do
      it 'フォロワー一覧ページが閲覧できる' do
        log_in_as(user)
        is_expected.to eq(200)
        expect(response.body).to include(full_title("Followers"))
      end
    end
  end

  describe 'GET /users/:id/following' do
    let(:user) { create(:user, :michael) }
    let(:id)   { user.id }

    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされる' do
        is_expected.to eq(302)
        expect(response.body).to redirect_to(login_path)
      end
    end

    context 'ログインしている時' do
      it 'フォロー中のユーザー一覧ページが閲覧できる' do
        log_in_as(user)
        is_expected.to eq(200)
        expect(response.body).to include(full_title("Following"))
      end
    end
  end
end
