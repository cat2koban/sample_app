require 'rails_helper'

RSpec.describe 'UsersSignup', type: :system do
  before do
    visit signup_path
  end

  scenario '無効なユーザー情報だと登録できない' do
    fill_in 'Name', with: 'a'*51
    click_button 'Create my account'
    expect(page).to have_content 'Name is too long (maximum is 50 characters)'
    fill_in 'Email', with: 'invalid@invalid'
    click_button 'Create my account'
    expect(page).to have_content 'Email is invalid'
    expect(page).to have_content 'Password can\'t be blank'
    fill_in 'Password', with: 'foo'
    fill_in 'Password confirmation', with: 'foo'
    click_button 'Create my account'
    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    fill_in 'Password', with: 'foobarbaz'
    fill_in 'Password confirmation', with: 'inva1iddddd'
    click_button 'Create my account'
    expect(page).to have_content 'Password confirmation doesn\'t match Password'
  end

  scenario '有効なユーザー情報だと登録できる' do
    expect{
      fill_in 'Name',     with: 'valid user'
      fill_in 'Email',    with: 'thisUseris@invalid.com'
      fill_in 'Password', with: 'va1idPassw0rd!'
      fill_in 'Password confirmation', with: 'va1idPassw0rd!'
      click_button 'Create my account'
    }.to change{ ActionMailer::Base.deliveries.size }.from(0).to(1)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Please check your email to activate your account.'
    user = User.find_by(email: 'thisuseris@invalid.com')

    activation_url = ActionMailer::Base.deliveries.last.body.encoded.match(
      "^http.*?#{CGI.escape(user.email)}"
    ).to_s.sub(
      /3000/,
      Capybara.current_session.server.port.to_s
    )
    visit activation_url.sub(/email.+/, "")
    have_text?('Invalid activation link')

    visit activation_url
    have_text?('Account activated!')
    expect(user.reload.activated?).to be_truthy
  end
end
