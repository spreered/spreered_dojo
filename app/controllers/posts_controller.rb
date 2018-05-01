class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :collect, :uncollect]
  def index
    @posts = Post.published.page(params[:page]).per(20)
  end

  def show
    #要檢查可不可以看
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments
    @post.view_count += 1
    @post.save!
  end

  def new
    @post = Post.new
  end
  def create
    @post = current_user.posts.build(post_params)
    @post.published_at = Time.zone.now if publishing?
    if @post.save!
      redirect_to post_path(@post)
    else
      render new_post_path(@post)
    end
  end

  def edit
  end
  def update
    @post.published_at = Time.zone.now if publishing?
    @post.published_at = nil if saving_as_draft?
    if @post.update!(post_params)
      flash[:notice] = '文章更新成功'
      redirect_to post_path(@post)
    else
      flash[:alert] = '更新失敗'
      render edit_post_path(@post)
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = '文章已刪除'
    redirect_to posts_path
  end
  def collect
    if @post.is_collected?(current_user)
      flash[:alert] = '錯誤'
      redirect_back(fallback_location: root_path)
    else
      @post.collect_users<<current_user
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
  def uncollect
    if @post.is_collected?(current_user)
      collects = @post.collects.where(user: current_user)
      collects.destroy_all
    else
      redirect_to post_path(@post)
    end
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title,:content,:image,:who_can_see,category_ids:[])
  end

  def publishing?
    params[:commit] == 'publish'
  end

  def saving_as_draft?
    params[:commit] == 'draft'
  end


end
