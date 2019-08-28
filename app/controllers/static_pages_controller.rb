class StaticPagesController < ApplicationController
  def home
    # ログインしている時のみ定義される
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
