class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create]

  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.new(comment_params.merge(user: current_user))

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @post.event }
        format.json { render json: @comment, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to @post.event, alert: "Could not add reply." }
        format.json { head :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/:id
  def destroy
    @comment = Comment.find(params[:id])
    event = @comment.post.event

    # Ensure only the commenter or event host can delete the comment
    if @comment.user == current_user || event.user == current_user
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to event }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to event, alert: "You cannot delete this reply." }
        format.json { head :forbidden }
      end
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
