class Comment < ApplicationRecord
  belongs_to :post, counter_cache: :replies_count
  belongs_to :author, class_name: 'User'
  after_create_commit :set_up_create
  after_destroy_commit :delete_chatterbox

  private

  def set_up_create
    user = self.post.author
    user.chatterbox_count += 1
    user.save!

    post.update!(replied_at: Time.zone.now)
    
  end

  def delete_chatterbox
    user = self.post.author
    user.chatterbox_count -= 1
    user.chatterbox_count  = (user.chatterbox_count < 0)? 0 : user.chatterbox_count
    user.save!
  end
end
