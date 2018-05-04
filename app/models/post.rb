class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader
  validates_presence_of :title, :content
  belongs_to :author, class_name: 'User'
  has_many :comments
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
  has_many :collects, dependent: :destroy
  has_many :collect_users, through: :collects, source: :user
  enum who_can_see: [:all_user,:friend,:myself]

  scope :published, -> {
    where('published_at IS NOT NULL')
  }
  scope :find_draft, -> {
    where('published_at IS NULL')
  }

  scope :friend_post, -> (user){
    where('author_id in (?) or author_id = ?',user.friends.map{|x|x.id}, user.id).friend
  }
  scope :myself_post, ->(user){
    where('author_id = ?', user.id).myself
  }

  def is_collected?(user)
    self.collect_users.include?(user)
  end

  def can_see_by?(user)
    return true if self.all_user?||self.author == user
    if self.friend?
      return user.is_friend?(self.author)
    else
      return false
    end
  end
end
