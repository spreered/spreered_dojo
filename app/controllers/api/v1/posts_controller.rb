class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: :index
  def index
    @posts = Post.published.all_user
    render json: {
      data: @posts.map do |post|
        {
          title: post.title,
          replies_count: post.replies_count,
          view_count: post.view_count,
          last_reply: post.updated_at
         }
       end
    }
  end
  def show 
    @post = Post.find_by(id:params[:id])
    if @post.can_see_by?(current_user)
      render json: {
        data: @post
      }
    else
      render json: {
        message: "you can't see the post"
      }
    end
  end
  def create
    @post = Post.new(post_params)
    @post.author = current_user
    @post.published_at = Time.zone.now
    if @post.save
      render json: {
        message: "post created successfully!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  def update
    @post = Post.find_by(id:params[:id])
    if @post.author == current_user || current_user.admin?
      if @post.update(post_params)
        @post.published_at = Time.zone.now
        @post.save
        render json: {
          message: "post updated successfully!",
          result: @post
        }
      else
        render json: {
          errors: @post.errors
        }
      end
    else
      render json: {
          errors: "not allowed"
        }
    end
  end

  def destroy
    @post = Post.find_by(id:params[:id])
    if @post.author == current_user || current_user.admin?
      @post.destroy
      render json: {
        message: "post delete!"
      }
    else
      render json: {
        message: "access denied"
      }
    end
  end


  private

  def post_params
    params.permit(:title,:content,:image,:who_can_see,category_ids:[])
  end
end
