class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:create]

  def create
    @post = @event.posts.build(post_params.merge(user: current_user))

    if @post.save
      redirect_to @event, notice: "Post added!"
    else
      redirect_to @event, alert: "Could not add post."
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.user == current_user || @post.event.user == current_user
      @post.destroy
      redirect_to @post.event, notice: "Post removed."
    else
      redirect_to @post.event, alert: "You cannot delete this post."
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
