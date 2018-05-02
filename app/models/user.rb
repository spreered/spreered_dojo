class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  mount_uploader :avatar, AvatarUploader
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy
  has_many :collects, dependent: :destroy
  has_many :collect_posts, through: :collects, source: :post

  has_many :friendships
  has_many :friendships_invitees, class_name:'User', through: :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friendships_inviters, class_name:'User', through: :inverse_friendships

  def admin?
    self.role=='admin'
  end
  def can_invite?(user)
    !self.friendships_invitees.include?(user) || !self.friendships_inviters.include?(user)
  end
  def is_friend?(user)
    self.friends.include?(user)
  end
  def inviting_friends
    self.friendships_invitees.where('friendships.is_friend = ?', false)
  end
  def inviting_me_friends
    self.friendships_inviters.where('friendships.is_friend = ? ', false)
  end

  def friendship_status(user)
    if user == self 
      return :self
    end

    if self.friends.include?(user)
      :friend
    elsif self.friendships_invitees.include?(user)
      :inviting
    elsif self.friendships_inviters.include?(user)
      :inviter
    else
      :can_invite
    end

  end
  def destroy_friendship!(user)
    ActiveRecord::Base.transaction do
      self.friendships.where(friend_id: user.id).destroy_all
      self.inverse_friendships.where(user_id: user.id).destroy_all
    end
  end
  def friends
    self.friendships_invitees.where('friendships.is_friend = ? ',true)
  end
end
