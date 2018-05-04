class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:edit,:update, :destroy]
  def index
    @categories = Category.all
    @category = Category.new
  end
  def create
    @category = Category.new(category_params)
    if @category.save!
      redirect_to admin_categories_path
    else
      render  admin_categories_path
    end
  end
  def edit
    render json:{name: @category.name}
  end
  def update
    @category.update!(category_params)
    render json: { id: @category.id, name: @category.name }
  end
  def destroy
    if @category.posts.count > 0
      render json: {message:'denied'}
    else
      @category.destroy
      render json: {message:'ok'}
    end
  end
  private
  def category_params
    params.require(:category).permit(:name)
  end
  def set_category
    @category = Category.find(params[:id])
  end
end
