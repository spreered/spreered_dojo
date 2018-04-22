class CreateUserCollects < ActiveRecord::Migration[5.1]
  def change
    create_table :user_collects do |t|
      t.integer :user_id
      t.integer :post_id
      t.index :user_id
      t.index :post_id
      t.timestamps
    end
  end
end
