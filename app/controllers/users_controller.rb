class UsersController < ApplicationController
  before_action :set_user
  def show
    @posts = @user.posts.published
  end
  def edit
  end
  def update
    if @user.update!(user_params)
      flash[:notice] = '更新成功'
      redirect_to user_path(@user)
    else
      flash[:alert] = '更新失敗'
      render edit_user_path(@user)
    end
  end

  def post_page
    @posts = @user.posts.published
  end

  def collect_page
    @posts = @user.collect_posts.page(params[:page]).per(20)
  end

  def comment_page
    @comments = @user.comments.page(params[:page]).per(20)
  end

  def draft_page
  end

  def friend_page
  end

  def invite_friendship
    if current_user.can_invite?(@user)
      current_user.friendships.create!(friend_id:@user.id, is_friend: false)
      flash[:notice] = 'invite friend'
      render :reset_friend_btn
    else
      flash[:alert] = 'invite friend failed'
      redirect_back(fallback_location: root_path)
    end
  end
  def cancel_inviting
    if current_user.friendship_status(@user) == :inviting
      friendships = current_user.friendships.where(friend_id: @user.id)
      friendships.destroy_all
      flash[:notice] = 'cancel frienship inviting'
      render :reset_friend_btn
    else
      flash[:alert] = 'cancel frienship failed'
      redirect_back(fallback_location: root_path)
    end
  end
  
  def unfriend
    if current_user.is_friend?(@user)
      current_user.destroy_friendship!(@user)
      flash[:notice] = 'unfriend'
      render :reset_friend_btn
    else
      flash[:alert] = 'unfriend failed'
      redirect_back(fallback_location: root_path)
    end
  end

  def accept_frienship
    if current_user.friendship_status(@user) == :inviter
      friendships = current_user.inverse_friendships.where(user_id: @user.id)
      friendships[0].update!(is_friend: true)
      current_user.friendships.create!(friend_id: @user.id, is_friend: true)
      flash[:notice] = 'accept friend invite'
      render :reset_friend_btn
    else
      flash[:alert] = 'accept friend invite failed'
      redirect_back(fallback_location: root_path)
    end
  end

  def ignore_frienship
    if current_user.friendship_status(@user) == :inviter
      current_user.inverse_friendships.where(user_id: @user.id).destroy_all
      flash[:notice] = 'ignore friend invite'
      render :reset_friend_btn
    else
      flash[:alert] = 'ignore friend invite failed'
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:name,:description,:avatar)
  end
end
