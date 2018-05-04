class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @categories = Category.all
    @q = @category.posts.published.all_user.or(@category.posts.published.friend_post(current_user)).or(@category.posts.published.myself_post(current_user)).ransack(params[:q])
    @posts = @q.result(distinct: true).order(id: :desc).page(params[:page]).per(20)
  end
end
