require 'rails_helper'

RSpec.describe 'PasswordResets', type: :system do
  scenario 'Passwordを忘れたので再設定する' do
    user = create(:user)
    visit new_password_reset_path
    expect{
      fill_in 'Email',  with: user.email
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
    visit reset_url
    fill_in 'Password',     with: 'cat2kobanisAwesome'
    fill_in 'Confirmation', with: 'cat2kobanisAwesome'
    click_on 'Update password'
    expect(current_path).to eq user_path(user.reload)
    expect(user.reset_digest).to be_nil

    # 設定したパスワードで入れるか確認
    click_on 'Account'
    click_on 'Log out'
    click_on 'Log in'
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: 'cat2kobanisAwesome'
    click_button 'Log in'
  end
end
