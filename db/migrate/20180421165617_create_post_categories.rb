class CreatePostCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :post_categories do |t|
      t.integer :category_id
      t.integer :post_id
      t.index :category_id
      t.index :post_id
      t.timestamps
    end
  end
end
