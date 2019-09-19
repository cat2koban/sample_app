require 'rails_helper'

RSpec.describe 'Following', type: :system do
  let(:user)    { create(:user) }
  let(:archer)  { create(:user, :archer) }
  let(:michael) { create(:user, :michael) }
  let(:create_microposts) {
    create_list(:micropost, 5, user: michael)
  }
  let(:login_user) { log_in_as(user, by_capybara: true)}
  before {
    user.follow(michael)
  }

  scenario '/following ページの閲覧' do
    login_user
    visit following_user_path(user)
    user.following.paginate(page: 1).each do |following_user|
      expect(page).to have_link(
        following_user.name,
        href: user_path(following_user)
      )
    end
  end

  scenario '/followers ページの閲覧' do
    log_in_as(michael, by_capybara: true)
    user.followers.paginate(page: 1).each do |followed_user|
      expect(page).to have_link(
        followed_user.name,
        href: user_path(followed_user)
      )
    end
  end

  scenario 'ユーザーをフォローする' do
    login_user
    visit user_path(archer)
    expect(current_path).to eq(user_path(archer))
    click_button 'Follow'
    has_text?('Unfollow')
    expect(user.following.pluck(:id).include?(archer.id)).to be_truthy
  end

  scenario 'ユーザーのフォローを解除する' do
    login_user
    visit user_path(michael)
    expect(current_path).to eq(user_path(michael))
    click_button 'Unfollow'
    has_text?('Follow')
    expect(user.following.pluck(:id).include?(michael.id)).to be_falsey
  end

  scenario '/ でフォローしたユーザーのマイクロポストが閲覧できる' do
    login_user
    create_microposts
    visit root_path
    expect(current_path).to eq(root_path)
    hoge = all('li', :text => /micropost-*/)
    user.feed.paginate(page: 1).each do |micropost|
      page.has_text?(CGI.escapeHTML(micropost.content))
    end
  end
end
