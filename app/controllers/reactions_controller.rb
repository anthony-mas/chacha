class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create]

  # POST /posts/:post_id/reactions
  def create
    # Reactions are simple: a user either has one or doesn't.
    # This creates the association (liking the post).
    @reaction = @post.reactions.new(user: current_user)

    if @reaction.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # DELETE /posts/:post_id/reactions/:id (or find by user/post pair)
  def destroy
    # Assuming we are deleting the current user's reaction for the post
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

  # No strong params needed as reactions simply link a user to a post
end
