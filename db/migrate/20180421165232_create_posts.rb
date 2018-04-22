class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :author_id
      t.string :content
      t.integer :replies_count
      t.integer :view_count
      t.boolean :is_draft
      t.string :who_can_see
      t.index :author_id
      t.timestamps
    end
  end
end
