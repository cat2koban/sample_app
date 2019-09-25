require 'rails_helper'

RSpec.describe 'UsersProfile', type: :system do
  let(:user)       { create(:user) }
  let(:microposts) { create_list(:micropost, 5, user: user) }

  before do
    visit user_path(user)
  end

  scenario 'ページのタイトル, h1タグにはユーザー名が含まれる' do
    expect(page).to have_title(full_title(user.name))
    expect(page).to have_css('h1', text: user.name)
  end

  scenario 'gravatarタグが存在する' do
    expect(page).to have_css('h1>img.gravatar')
  end

  scenario '投稿したマイクロポスト数を表示' do
    microposts
    visit user_path(user)
    expect(page).to have_css('h3', text: "Microposts (#{user.microposts.count.to_s})")
  end

  scenario 'ユーザーが投稿したマイクロポストを表示' do
    microposts
    user.microposts.paginate(page: 1).each do |micropost|
      page.has_text?(CGI.escapeHTML(micropost.content))
    end
  end
end
