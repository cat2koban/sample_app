require 'rails_helper'

RSpec.describe 'UsersIndex', type: :system do
  before do
    create_list(:other_user, 50)
  end

  scenario '管理者権限によりアカウント一覧からユーザーを削除する' do
    admin = create(:user, :michael)
    log_in_as(admin, by_capybara: true)
    click_on 'Users'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      expect(page).to have_css('li', text: user.name)
      unless user == admin
        expect(page).to have_css('li', text: 'delete')
      end
    end
    users_length = User.count
    first('a', text: 'delete').click
    page.driver.browser.switch_to.alert.accept
    visit users_path
    expect(User.count).to eq(users_length-1)
  end

  scenario '非管理者には削除リンクが見えない' do
    non_admin = create(:user)
    log_in_as(non_admin, by_capybara: true)
    click_on 'Users'
    expect(page).to_not have_content('delete')
  end
end
