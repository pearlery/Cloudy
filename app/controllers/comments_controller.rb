class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
  
    if @comment.save
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Comment added!" }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path, alert: "Failed to add comment." }
        format.js
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
