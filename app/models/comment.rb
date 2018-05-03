class Comment < ApplicationRecord
  belongs_to :post, counter_cache: :replies_count
  belongs_to :author, class_name: 'User'
  after_create_commit :add_chatterbox
  after_destroy_commit :delete_chatterbox

  private

  def add_chatterbox
    user = self.post.author
    user.chatterbox_count += 1
    user.save!
  end

  def delete_chatterbox
    user = self.post.author
    user.chatterbox_count -= 1
    user.chatterbox_count  = (user.chatterbox_count < 0)? 0 : user.chatterbox_count
    user.save!
  end
end
