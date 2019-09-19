require 'rails_helper'
Capybara.server = :webrick

RSpec.describe "UsersLogin", type: :system do
  let(:user) { create(:user) }

  scenario 'ログインに失敗する' do
    visit root_path
    click_on 'Log in'
    fill_in 'Email',    with: "invalid@example.com"
    fill_in 'Password', with: "foobar"
    find(".btn").click
    expect(page).to have_content("Invalid")
  end

  scenario 'ログインに成功し、ログアウトする' do
    visit root_path
    click_on 'Log in'
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    find(".btn").click
    expect(current_path).to eq user_path(user)
    click_on 'Account'
    click_on 'Log out'
    expect(current_path).to eq root_path
  end
end
