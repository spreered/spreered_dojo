class AddRepliedAtInPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :replied_at, :datetime
    Post.find_each do |post|
      post.replied_at = post.updated_at
      post.save
    end
  end

end
