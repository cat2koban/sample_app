require 'rails_helper'

RSpec.describe 'PasswordResets', type: :system do
  scenario 'Passwordを忘れたので再設定する' do
    user = create(:user)
    visit new_password_reset_path

    expect{
      fill_in 'Email', with: 'invalid@invalid.com'
      click_button 'Submit'
    }.to_not change{ ActionMailer::Base.deliveries.size }
    expect(page).to have_selector('div.alert-danger')
    have_text?('Email address not found')

    expect{
      fill_in 'Email', with: user.email
      click_button 'Submit'
    }.to change{ ActionMailer::Base.deliveries.size }.from(0).to(1)

    # ActionMailerが送信した最後のメールのreset_url部分を取得して
    # ポート番号をCapybara.current_session.server.portで置換している
    reset_url = ActionMailer::Base.deliveries.last.body.encoded.match(
      "^http.*?#{CGI.escape(user.email)}"
    ).to_s.sub(
      /3000/,
      Capybara.current_session.server.port.to_s
    )
    user.toggle!(:activated)
    visit reset_url
    expect(current_path).to eq root_path

    user.toggle!(:activated)
    visit reset_url.sub(/email.+/, "")
    expect(current_path).to eq root_path

    visit reset_url
    fill_in 'Password',     with: 'piyo'
    fill_in 'Confirmation', with: 'piyo'
    click_on 'Update password'
    have_selector('div#error_explanation')
    have_text?('Password is too short (minimum is 6 characters)')

    fill_in 'Password',     with: 'cat2kobanisAwesome'
    fill_in 'Confirmation', with: 'piyopiyo!'
    click_on 'Update password'
    have_selector('div#error_explanation')
    have_text?('Password confirmation doesn\'t match Password')

    fill_in 'Password',     with: 'cat2kobanisAwesome'
    fill_in 'Confirmation', with: 'cat2kobanisAwesome'
    click_on 'Update password'
    expect(current_path).to eq user_path(user.reload)
    expect(user.reset_digest).to be_nil

    log_out
    click_on 'Log in'
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: 'cat2kobanisAwesome'
    click_button 'Log in'
  end
end
