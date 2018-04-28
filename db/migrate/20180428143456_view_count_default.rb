class ViewCountDefault < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :view_count
    add_column :posts, :view_count, :integer, null: false, default: 0
  end
end
