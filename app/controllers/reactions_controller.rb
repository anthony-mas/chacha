class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create]

  def create
    @reaction = @post.reactions.new(user: current_user)

    if @reaction.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @reaction = Reaction.find_by!(user: current_user, post_id: params[:post_id])

    if @reaction.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
