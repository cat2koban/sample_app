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
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
