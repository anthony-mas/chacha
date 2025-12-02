class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    # Dashboard content
    @recent_posts = @user.posts.order(created_at: :desc).limit(5)
    @participations = @user.participations.includes(:event).order(created_at: :desc)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
