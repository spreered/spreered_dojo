class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader
  after_create_commit :set_replied_at
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

  def is_publish?
    return !(published_at == nil)
  end

  def can_see_by?(user)
    return false if !self.is_publish?&&self.author != user
    return true if self.all_user?||self.author == user
    if self.friend?
      return user.is_friend?(self.author)
    else
      return false
    end
  end
  def update_replied_at!
    if self.comments.empty?
      self.replied_at = self.created_at
    else
      self.replied_at = self.comments.last.created_at
    end
    self.save
  end

  private

  def set_replied_at
    self.replied_at = Time.zone.now
    self.save
  end
end
