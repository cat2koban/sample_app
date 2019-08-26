class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  # GET /password_resets/new
  def new
  end

  # POST /password_resets == password_resets_path
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      now = Time.zone.now
      @user.create_reset_digest(now)
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  # GET /password_resets/:id/edit
  def edit
  end

  # PATCH /password_resets/:id
  def update
  end

  private

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
end
