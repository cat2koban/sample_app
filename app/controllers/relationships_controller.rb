class RelationshipsController < ApplicationController
  before_action :redirect_unless_logged_in

  # POST /relationships
  def create
    @user = User.find(params[:followed_id])
    relation = current_user.follow(@user)
    unless relation.persisted?
      flash[:danger] = "Already followed this user"
    end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  # DELETE /relationships/:id
  def destroy
    puts params[:followed_id]
    relation = Relationship.find_by(id: params[:id])
    unless relation.nil?
      @user = relation.followed
      current_user.unfollow(@user)
      path = user_path(@user)
    else
      flash[:danger] = "Unfollowing users cannot be unfollowed"
      path = root_path
    end
    respond_to do |format|
      format.html { redirect_to path }
      format.js
    end
  end
end
