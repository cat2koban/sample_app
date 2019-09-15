def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{page_title} | #{base_title}"
  end
end

def log_in_as(user)
  post(login_path, params:{
    session: {
      email: user.email,
      password: user.password
    }
  })
end
