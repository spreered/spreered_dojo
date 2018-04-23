class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader
  validates_presence_of :title, :content
  belongs_to :author, class_name: 'User'

end
