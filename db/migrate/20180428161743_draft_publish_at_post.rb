class DraftPublishAtPost < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :is_draft
    add_column :posts, :published_at, :datetime
  end
end
