class DraftDefaultPost < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :is_draft
    add_column :posts, :is_draft, :boolean, null: false, default: false
  end
end
