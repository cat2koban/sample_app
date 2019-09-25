require 'rails_helper'

RSpec.describe 'PasswordResets', type: :system do
  let(:user)      { create(:user) }
  let(:send_mail) {
    fill_in 'Email', with: user.email
    click_button 'Submit'
  }
  let(:reset_url) {
    # ActionMailerが送信した最後のメールのreset_url部分を取得して
    # ポート番号をCapybara.current_session.server.portで置換している
    ActionMailer::Base.deliveries.last.body.encoded.match(
      "^http.*?#{CGI.escape(user.email)}"
    ).to_s.sub(
      /3000/,
      Capybara.current_session.server.port.to_s
    )
  }
  before do
    visit new_password_reset_path
  end

  scenario 'Email が存在しないと flash を表示' do
    expect{
      fill_in 'Email', with: 'invalid@invalid.com'
      click_button 'Submit'
    }.to_not change{ ActionMailer::Base.deliveries.size }
    expect(page).to have_content('Email address not found')
  end

  scenario 'Email が正しいと，メールが送信される' do
    expect{
      fill_in 'Email', with: user.email
      click_button 'Submit'
    }.to change{ ActionMailer::Base.deliveries.size }.from(0).to(1)
  end

  scenario 'アクティベイトされていないと，root_pathにリダイレクトする' do
    send_mail
    user.toggle!(:activated)
    visit reset_url
    expect(current_path).to eq root_path
  end

  scenario 'reset_url が正しくないと, root_pathにリダイレクト' do
    send_mail
    user.toggle!(:activated)
    visit reset_url.sub(/email.+/, "")
    expect(current_path).to eq root_path
  end

  scenario '無効なパスワードの場合，フラッシュが表示' do
    send_mail
    visit reset_url
    fill_in 'Password',     with: 'piyo'
    fill_in 'Confirmation', with: 'piyo'
    click_on 'Update password'
    expect(page).to have_content('Password is too short (minimum is 6 characters)')
  end

  scenario '無効なパスワードの組み合わせの場合，フラッシュが表示' do
    send_mail
    visit reset_url
    fill_in 'Password',     with: 'cat2kobanisAwesome'
    fill_in 'Confirmation', with: 'piyopiyo!'
    click_on 'Update password'
    expect(page).to have_content('Password confirmation doesn\'t match Password')
  end

  scenario '再設定したパスワードでログインできる。' do
    user
    send_mail
    visit reset_url
    new_password = 'cat2kobanisAwesome'
    fill_in 'Password',     with: new_password
    fill_in 'Confirmation', with: new_password
    click_on 'Update password'
    expect(current_path).to eq user_path(user.reload)
    expect(user.reset_digest).to be_nil
    log_out
    click_on 'Log in'
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: new_password + "hoge"
    click_button 'Log in'
    expect(page).to_not have_css('div#error_explanation')
  end
end
