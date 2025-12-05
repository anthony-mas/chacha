class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  # POST /posts/:post_id/reactions
  # Toggle: if user already reacted, remove it; otherwise create it
  def create
    existing = @post.reactions.find_by(user: current_user)

    if existing
      existing.destroy
      @reacted = false
    else
      @post.reactions.create!(user: current_user)
      @reacted = true
    end

    respond_to do |format|
      format.html { redirect_to @post.event }
      format.json { render json: { reacted: @reacted, count: @post.reactions.count } }
    end
  end

  def destroy
    @reaction = @post.reactions.find_by(user: current_user)

    if @reaction&.destroy
      respond_to do |format|
        format.html { redirect_to @post.event }
        format.json { render json: { reacted: false, count: @post.reactions.count } }
      end
    else
      head :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
