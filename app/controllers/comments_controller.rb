class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    @comment = post.comments.build(comment_params)
    @comment.author = current_user
    if @comment.save!
      flash[:notice] = '已留言'
      redirect_to post_path(post)
    else
      flash[:alert] = '留言失敗'
      render post_path(post)
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end 
end
