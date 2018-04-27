class CommentsController < ApplicationController
  before_action :set_comment, only:[:edit,:update,:destroy]
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
    render json:{content: @comment.content }
  end

  def update
    @comment.update!(comment_params)
    render json: { id: @comment.id, content: @comment.content }
  end

  def destroy
    post = Post.find(params[:post_id])
    @comment.destroy
    flash[:notice] = 'comment delete!'
    redirect_to post_path(post)
  end

  private
  def set_comment
    @comment = Comment.find(params[:id])
  end
  def comment_params
    params.require(:comment).permit(:content)
  end 
end
