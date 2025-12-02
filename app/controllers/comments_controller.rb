class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create]

  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.new(comment_params.merge(user: current_user))

    if @comment.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # DELETE /comments/:id
  def destroy
    @comment = Comment.find(params[:id])

    # Ensure only the commenter or a post owner can delete the comment
    if @comment.user == current_user
      @comment.destroy
      head :ok
    else
      head :forbidden
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    # Allows content to be set, as per schema
    params.require(:comment).permit(:content)
  end
end
