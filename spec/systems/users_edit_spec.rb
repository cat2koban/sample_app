require 'rails_helper'

RSpec.describe 'UsersEdittingProfile', type: :system do
  let(:user) { create(:user) }
  before do
    log_in_as(user, by_capybara: true)
    visit edit_user_path(user)
  end

  scenario '無効なメールアドレスを入力すると，更新できない' do
    fill_in 'Email',    with: 'invalid@invalid'
    click_button 'Save changes'
    expect(page).to have_content 'Email is invalid'
  end

  scenario '無効なパスワードを入力すると，更新できない' do
    fill_in 'Password', with: 'foo'
    fill_in 'Password confirmation', with: 'foo'
    click_button 'Save changes'
    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    fill_in 'Password', with: 'foobarbaz'
    fill_in 'Password confirmation', with: 'invalidinvalid'
    click_button 'Save changes'
    expect(page).to have_content 'Password confirmation doesn\'t match Password'
  end

  scenario '正しい変更内容で更新する' do
    fill_in 'Name',     with: 'catcatkoban'
    fill_in 'Email',    with: 'goodemail@okok.com'
    fill_in 'Password', with: 'foobarbaz'
    fill_in 'Password confirmation', with: 'foobarbaz'
    click_button 'Save changes'
    expect(page).to_not have_css('div#error_explanation')
  end
end
