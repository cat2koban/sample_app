def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{page_title} | #{base_title}"
  end
end

def log_in_as(user, options={})
  unless options[:by_capybara]
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password,
        remember_id: '1'
      }
    }
  else
    visit root_path
    click_on 'Log in'
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    check 'session_remember_me'
    click_button 'Log in'
  end
end

def log_out
  click_on 'Account'
  click_on 'Log out'
end
