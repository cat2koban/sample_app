require 'rails_helper'

RSpec.describe "MicropostsInterface", type: :system do
  let(:user)             { create(:user) }
  let(:microposts)       { create_list(:micropost, 5, user: user) }
  let(:other_user)       { create(:other_user) }
  let(:other_microposts) { create_list(:other_micropost, 5, user: other_user) }
  let(:image_path)       { File.join(Rails.root, 'test/fixtures/rails.png') }

  before {
    microposts
  }

  scenario 'マイクロポストを投稿し，削除する' do
    log_in_as(user, by_capybara: true)
    click_on 'Home'
    expect{
      click_button 'Post'
    }.to_not change{Micropost.count}
    expect(page).to have_css('div#error_explanation')
    expect{
      fill_in 'micropost_content', with: Faker::Lorem.sentence(word_count: 5)
      attach_file 'micropost_picture', image_path
      click_button 'Post'
    }.to change{Micropost.count}.from(Micropost.count).to(Micropost.count+1)
    expect(page).to have_selector('div.alert-success')
    expect(page).to have_selector('a',text: 'delete')
    expect{
      first('a', text: 'delete').click
      page.driver.browser.switch_to.alert.accept
      visit current_path
    }.to change{Micropost.count}.from(Micropost.count).to(Micropost.count-1)
  end

  scenario '他のユーザーのマイクロポストには削除リンクがない' do
    other_microposts
    visit login_path
    log_in_as(user, by_capybara: true)
    visit user_path(other_user)
    expect(page).to_not have_selector('a',text:'delete')
  end

  scenario 'サイドバーのマイクロポスト数が表示されている' do
    log_in_as(user, by_capybara: true)
    click_on 'Home'
    expect(page).to have_selector('span',text:"#{user.microposts.count} microposts")
    log_out
    log_in_as(other_user, by_capybara: true)
    click_on 'Home'
    expect(page).to have_selector('span', text: "0 micropost")
    other_user.microposts.create!(content: "new content")
    click_on 'Home'
    expect(page).to have_selector('span', text: '1 micropost')
  end
end
