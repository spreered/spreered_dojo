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
  def is_collected?(user)
    self.collect_users.include?(user)
  end
end
