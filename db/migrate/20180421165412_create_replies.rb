class CreateReplies < ActiveRecord::Migration[5.1]
  def change
    create_table :replies do |t|
      t.integer :author_id
      t.integer :post_id
      t.text :content
      t.index :author_id
      t.index :post_id
      t.timestamps
    end
  end
end
