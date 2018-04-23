class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end
  def update
    @user = User.find(params[:id])
    @user.update!(user_params)
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit(:role)
  end
  
end
